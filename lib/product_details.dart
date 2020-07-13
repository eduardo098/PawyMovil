import 'package:flutter/material.dart';
import 'models/product.dart';

class ProductDetails extends StatefulWidget {
  String nombre;
  String precio;
  String descripcion;

  ProductDetails({this.nombre, this.precio, this.descripcion});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int productQuantity = 1;

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
                  "https://www.tourinews.es/uploads/s1/16/86/25/paisaje-2.jpeg",
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
                            child: Text(widget.nombre, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, color: Colors.greenAccent,))
                          )
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 20, left: 40),
                              child: productCounter(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20, right: 40),
                              child: Text("\$" + widget.precio + " MXN", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, color: Colors.greenAccent,),)
                            )
                          ],
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 40, left: 20),
                            child: Text("Descripción", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.greenAccent,))
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            widget.descripcion,
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
                              onPressed: () {},
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