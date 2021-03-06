import 'package:flutter/material.dart';
import 'models/product.dart';
import 'localDB/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class ProductDetails extends StatefulWidget {
  Producto producto;

  ProductDetails({this.producto});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int productQuantity = 1;
  String serverUrl = "http://192.168.1.67";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          //height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                height: 350,
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  serverUrl + widget.producto.imgUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 40, left: 20),
                child: GestureDetector(
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
                )
              ),
              Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height - 500),
                  //height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 40, left: 20),
                            child: Text(widget.producto.nombreProducto, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, color: Colors.greenAccent,))
                          )
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 20, left: 20),
                              child: productCounter(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20, right: 40),
                              child: Text("\$" + widget.producto.precio + " MXN", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, color: Colors.greenAccent,),)
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 20, left: 20),
                                child: Text("Categoría:", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.greenAccent,))
                              )
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 20, left: 10),
                                child: Text(widget.producto.categoria, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,))
                              )
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 20, left: 20),
                                child: Text("Stock:", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.greenAccent,))
                              )
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 20, left: 10),
                                child: Text(widget.producto.stock, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,))
                              )
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 20, left: 20),
                            child: Text("Descripción", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.greenAccent,))
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            widget.producto.descProducto,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              letterSpacing: 0.0125,
                            ),
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 40),
                          child: SizedBox(
                            height: 50,
                            width: 220,
                            child: RaisedButton.icon(
                              color: Colors.greenAccent,
                              icon: Icon(Icons.add_shopping_cart),  
                              onPressed: () async {
                                if(int.parse(widget.producto.stock) > 0 && productQuantity <= int.parse(widget.producto.stock)) {
                                  _insertProduct(widget.producto);
                                  _query();
                                  final snackBar = SnackBar(
                                    content: Text('Artículo añadido.'),
                                  );
                                  // Find the Scaffold in the widget tree and use it to show a SnackBar.
                                  Scaffold.of(context).showSnackBar(snackBar);
                                } else {
                                  noStockDialog("Lo sentimos, este producto no está disponible.");
                                }
                              },
                              label: Text("Agregar al carrito"),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        )    
                      ],
                    ),
                  ),    
                )
            ],
          ),
        )
      )
    );
  }

  void noStockDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
                width: double.maxFinite,
                child: Text(message)
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
      }
    );
  }

  void _insertProduct(Producto producto) async {
    var res = await DatabaseHelper.db.insertItem(producto, productQuantity);
    print(res);
  } 

  void _query() async {
    var res = await DatabaseHelper.db.getAllProducts();
    print(res);
    for (int i = 0; i < res.length; i++) {
      print("Producto ${i}:: " + res[i].idProducto + " | " + res[i].nombreProducto + " | " + res[i].precio + " | " + res[i].cantidad);
    }
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