import 'package:flutter/material.dart';
import 'package:pawyapp/utils/utils.dart';
import 'product_details.dart';
import 'models/product.dart';
import 'localDB/db_helper.dart';
import 'dart:convert';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  int productQuantity = 1;
  List products;
  Map<String, dynamic> orderItems;
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
          FutureBuilder(
            future: DatabaseHelper.db.getAllProducts(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //List for database;
                products = snapshot.data;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    Producto producto = snapshot.data[index];
                    return Dismissible(
                      direction: DismissDirection.endToStart,
                      key: UniqueKey(),
                      background: Container(
                        alignment: AlignmentDirectional.centerEnd,
                        color: Colors.redAccent,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                          child: Icon(Icons.delete_sweep, color: Colors.white, size: 30,)
                        )
                      ),
                      onDismissed: (direction){
                        DatabaseHelper.db.deleteProduct(int.parse(producto.idLocal));
                      },
                      child: shoppingCartItem(producto)
                    );
                  }
                );
              }
            }
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
                  onPressed: () {
                    List items = [];
                    for(int i = 0; i < products.length; i++) {
                      //var producto = new Producto(cantidad: products[i].cantidad, idProducto: products[i].idProducto);
                      //items.add(producto);
                      var itemsMap = {
                        "cantidad": products[i].cantidad,
                        "idProducto": products[i].idProducto
                      };

                      items.add(itemsMap);
                    }
                    //print("JSON DATA::: " + jsonEncode(items));
                    placeOrder(items);
                  },
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

  Widget shoppingCartItem(Producto producto) {
    return Container(
      height: 120,
      padding: EdgeInsets.only(top: 5, bottom: 5),
      width: MediaQuery.of(context).size.width,
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
                    child: Text(producto.nombreProducto, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700))
                  )
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, left: 20),
                    child: Text("\$" + producto.precio, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700))
                  )
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Transform.scale(
                scale: 0.7,
                child: ProductCounter(quantity: int.parse(producto.cantidad)),
              )
            ) 
          ]
        ),
      )
    );
  }
}

class ProductCounter extends StatefulWidget {
  int quantity;
  ProductCounter({this.quantity});
  @override
  _ProductCounterState createState() => _ProductCounterState();
}

class _ProductCounterState extends State<ProductCounter>{
  @override
  Widget build(BuildContext context) {

    int productQuantity = widget.quantity;

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