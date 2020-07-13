import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
          ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              orderItem(),
              orderItem(),
              orderItem(),
              orderItem(),
              orderItem(),
              orderItem(),
            ],
          )
        ],
      )
    );
  }

  Widget orderItem() {
    return Container(
      height: 140,
      width: MediaQuery.of(context).size.width - 60,
      child: Card(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 10, left: 15),
                child: Text("ID de Orden: #4245353", style: TextStyle(fontWeight: FontWeight.w700),)
              )
            ),
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
                        child: Text("Producto X", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700))
                      )
                    ),
                    Align(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text("\$99,99", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700))
                      )
                    ),
                  ],
                ),
                Align(
                  child: Padding(
                      padding: EdgeInsets.only(top: 10, left: 20),
                      child: Text("Cantidad: 3", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))
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