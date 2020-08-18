import 'package:flutter/material.dart';
import 'package:pawyapp/utils/utils.dart';
import 'models/product.dart';
import 'localDB/db_helper.dart';
import 'orders.dart';
import 'package:flutter/scheduler.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  int productQuantity = 1;
  double total = 0;
  List products;
  bool isCartEmpty = true;
  Map<String, dynamic> orderItems;
  Future<List> _shoppingCartItems;
  Future<dynamic> _shoppingCartTotal;
  String serverUrl = "http://192.168.1.67";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _shoppingCartItems = DatabaseHelper.db.getAllProducts();
    _shoppingCartTotal = DatabaseHelper.db.getTotal();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 40, left: 20, bottom: 20),
              child: Text(isCartEmpty ? "Mi Carrito" : "", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.greenAccent)),
            )
          ),
          FutureBuilder(
            future: _shoppingCartItems,
            builder: (context, snapshot) {
              if(snapshot.data.length == 0 && snapshot.connectionState == ConnectionState.done) {
                return Container(
                  padding: EdgeInsets.only(top: 100),
                  child: Center(
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          Image.asset("assets/images/shopping_cart_empty.png", height: 200, width: 200,),
                          Text("¡Vaya!, parece que tu carrito de compras \n está vacío.", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                          SizedBox(
                            height: 20
                          ),
                        ],
                      )
                    )
                  )
                );
              }  
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                products = snapshot.data;
                return ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Producto producto = snapshot.data[index];
                        /*
                        SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {
                          double totalPerProduct = double.parse(producto.precio) * double.parse(producto.cantidad);
                          total += totalPerProduct;
                        }));*/
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
                            setState(() {
                              _shoppingCartItems = DatabaseHelper.db.getAllProducts();
                            });
                          },
                          child: shoppingCartItem(producto)
                        );
                      }
                    ),
                    FutureBuilder(
                      future: _shoppingCartTotal,
                      builder: (BuildContext context, snapshot) {
                        return Padding(
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
                                  child: Text("\$"+ snapshot.data.toStringAsFixed(2), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ],
                          )
                        );
                      }
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
                              placeOrder(items).then((value) {
                                final snackBar = SnackBar(
                                  content: Text('Orden creada. ' + value.toString()),
                                  action: SnackBarAction(
                                    label: "VER ORDENES",
                                    onPressed: () {
                                      // Some code to undo the change.
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Orders()));
                                    },
                                  )
                                );
                                // Find the Scaffold in the widget tree and use it to show a SnackBar.
                                Scaffold.of(context).showSnackBar(snackBar);
                                DatabaseHelper.db.deleteAllProducts();
                                setState(() {
                                  _shoppingCartItems = DatabaseHelper.db.getAllProducts();
                                });
                              });
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
                );
              }  else {
                return Center(child: CircularProgressIndicator());
              }
            }
          ),
        ],
      )
    );
  }

  Widget shoppingCartItem(Producto producto) {
    double totalProducto = double.parse(producto.precio) * double.parse(producto.cantidad);
    return Container(
      height: 120,
      //padding: EdgeInsets.only(top: 5, bottom: 5),
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 5,
        child: Row(
          children: <Widget>[
            Container(
              height: 120,
              width: 120,
              child: Image.network(
               serverUrl + producto.imgUrl,
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
                    child: Text(producto.nombreProducto, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700))
                  )
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, left: 20),
                    child: Text("\$" + totalProducto.toStringAsFixed(2), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700))
                  )
                )
              ],
            ),
            Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text("Cantidad: " + producto.cantidad, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))
              )
            ) 
          ]
        ),
      )
    );
  }
  @override
  void dispose() {
    super.dispose();
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