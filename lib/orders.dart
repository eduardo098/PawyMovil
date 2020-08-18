import 'package:flutter/material.dart';
import 'utils/utils.dart';
import 'models/orderitem.dart';
import 'package:grouped_listview/grouped_listview.dart';
import 'order_details.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  Future<List<ItemOrden>> _orderItems;
  List<ItemOrden> groupedContent;
  String serverUrl = "http://192.168.1.67";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _orderItems = fetchOrderItems();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          topBar(),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            height: MediaQuery.of(context).size.height-120,
            child: orderListView()
          )
        ],
      )
    );
  }

  Widget topBar() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
              height: 50,
              width: 50,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: Colors.white,
                child: Icon(Icons.arrow_back_ios, size: 18, color: Colors.greenAccent),
              )
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text("Mis Ordenes", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.greenAccent)),
            )
          ),
        ],
      )
    );
  }

  Widget orderListView() {
    return FutureBuilder(
      future: _orderItems,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          groupedContent = snapshot.data;
          return GroupedListView(
            collection: groupedContent,
            groupBy: (ItemOrden item) => item.idOrden,
            listBuilder: (BuildContext context, ItemOrden item) => orderItem(item),
            groupBuilder: (BuildContext context, String name) {
              return InkWell(
                onTap: () {
                  List<ItemOrden> items = groupedContent.where((ItemOrden item) => item.idOrden.contains(name)).toList();
                  Navigator.of(context).
                  push(MaterialPageRoute(builder: (context) => OrderDetails(
                    orderNumber: name,
                    orderItems: items
                  ))).then((value) => value ? setState(() {_orderItems = fetchOrderItems();}) : null);
                },
                child: Container(
                  padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Text(name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),),
                      Spacer(),
                      Icon(Icons.arrow_right, size: 30, color: Colors.black87)
                    ],
                  )
                ),
              );
            } 
          );
        } else {
          return Container(
            padding: EdgeInsets.only(top: 40),
            child: Center(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Image.asset("assets/images/empty_orders.png",),
                    Text("Todo bien por aquí.", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                    SizedBox(
                      height: 10
                    ),
                    Text("No tienes ordenes pendientes.", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                  ],
                )
              )
            )
          );
        }
      }
    );
  }

  Widget orderItem(ItemOrden item) {
    return Container(
      height: 110,
      width: MediaQuery.of(context).size.width - 60,
      child: Card(
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 100,
                  width: 130,
                  child: Image.network(
                  serverUrl + item.imgUrl,
                  fit: BoxFit.cover,
                  )
                ),
                Column(
                  children: <Widget>[
                    Align(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, left: 20),
                        child: Text(item.nombreProducto, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700))
                      )
                    ),
                    Align(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, left: 20),
                        child: Text("\$99,99", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700))
                      )
                    ),
                  ],
                ),
                Spacer(),
                Align(
                  child: Padding(
                      padding: EdgeInsets.only(top: 10, left: 20, right: 30),
                      child: Text("Cantidad: 3", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700))
                  )
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}