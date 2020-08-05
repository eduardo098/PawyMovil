import 'package:flutter/material.dart';
import 'utils/utils.dart';
import 'models/orderitem.dart';
import 'package:grouped_listview/grouped_listview.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  Future<List<ItemOrden>> _orderItems;
  List<ItemOrden> groupedContent;
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
        shrinkWrap: true,
        children: <Widget>[
          Padding(
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
          ),
          //Text("CONTENIDO AGRUPADO"),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder(
            future: _orderItems,
            builder: (context, snapshot) {
              print(snapshot.data.length);
              if (snapshot.hasData) {
                groupedContent = snapshot.data;
                return GroupedListView(
                  collection: groupedContent,
                  groupBy: (ItemOrden item) => item.idOrden,
                  listBuilder: (BuildContext context, ItemOrden item) => orderItem(item),
                  groupBuilder: (BuildContext context, String name) {
                    return Padding(
                      padding: EdgeInsets.only(top: 20, left: 20),
                      child: Text(name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),)
                    );
                  } 
                );
              } else {
                return Text("Hay un error en el future");
              }
            }
          ),
          )
        ],
      )
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
                  padding: EdgeInsets.only(left: 15, top: 10),
                  height: 100,
                  width: 130,
                  child: Image.network(
                  "https://www.tourinews.es/uploads/s1/16/86/25/paisaje-2.jpeg",
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