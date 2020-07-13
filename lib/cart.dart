import 'package:flutter/material.dart';
import 'product_details.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  int productQuantity = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: ScrollPhysics(),
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 40, left: 20, bottom: 20),
              child: Text("Mi Carrito", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.greenAccent)),
            )
          ),
          ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              shoppingCartItem(),
              shoppingCartItem(),
              shoppingCartItem(),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text("Total: ", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
                SizedBox(
                  height: 50,
                  width: 100,
                  child: RaisedButton( 
                    color: Colors.greenAccent,
                    onPressed: () {},
                    child: Text("\$99,99", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            )
          ),
          Align(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                height: 50,
                width: 200,
                child: RaisedButton.icon( 
                  color: Colors.greenAccent,
                  onPressed: () {},
                  icon: Icon(Icons.check_circle),
                  label: Text("Ordenar", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            )
          )
        ],
      )
    );
  }

  Widget shoppingCartItem() {
    return Container(
      height: 120,
      padding: EdgeInsets.only(top: 5, bottom: 5),
      width: MediaQuery.of(context).size.width - 40,
      child: Card(
        elevation: 5,
        child: Row(
          children: <Widget>[
            Container(
              height: 120,
              width: 120,
              child: Image.network(
               "https://www.tourinews.es/uploads/s1/16/86/25/paisaje-2.jpeg",
               fit: BoxFit.cover,
              )
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, left: 20),
                    child: Text("Producto X", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700))
                  )
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, left: 20),
                    child: Text("\$99,99", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700))
                  )
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Transform.scale(
                scale: 0.7,
                child: productCounter(),
              )
            ) 
          ]
        ),
      )
    );
  }

  Widget productCounter() {
    return Row(
      children: <Widget>[
        SizedBox(
          height: 40,
          width: 40,
          child: RaisedButton(
            color: Colors.white,
            onPressed: () {
              setState(() {
                if (productQuantity == 1) {
                  return;
                } else {
                  productQuantity--;
                }

              });
            },
            child: Text("-", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ), 
          )
        ),
        Container(
          height: 40, 
          width: 40,
          color: Colors.white54,
          child: Align(
            alignment: Alignment.center,
            child: Text("$productQuantity", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          )
        ),
        SizedBox(
          height: 40,
          width: 40,
          child: RaisedButton(
            color: Colors.white,
            onPressed: () {
              setState(() {
                if (productQuantity == 10) {
                  return;
                } else {
                  productQuantity++;
                }
              });
            },
            child: Text("+", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ), 
          )
        ),
      ],
    );
  }
}