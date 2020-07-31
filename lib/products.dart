import 'package:flutter/material.dart';
import 'product_details.dart';
import 'package:pawyapp/utils/utils.dart';
import './models/product.dart';

class Products extends StatefulWidget {
  String categoria;
  Products({this.categoria});
  @override
  _ProductsState createState() => _ProductsState();
}


class _ProductsState extends State<Products> {
  Future<List> _products;
  List content;
  @override
  void initState() {
    super.initState();
    _products = fetchProductsByID(widget.categoria);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 60, left: 20),
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
                      child: Text("Categoria X", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.greenAccent)),
                    )
                  ),
                ],
              )
            ),
            FutureBuilder(
              future: _products,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  content = snapshot.data;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: content.length,
                    itemBuilder: (BuildContext context, int index) {
                      return featuredProductCard(context, content[index]);
                    }
                  );
                } else {
                  return Align(
                    alignment: Alignment.center,
                    child: Text("No hay productos en esta cetegoría")
                  );
                }
              }
            ),
          ], 
        ),
      )
    );
  }

  Widget featuredProductCard(BuildContext context, Producto product) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).
        push(MaterialPageRoute(builder: (context) => ProductDetails(
          producto: product,
        )));
      },
      child: Container(
        height: 210,
        width: 200,
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            children: <Widget>[
              Image.network("https://www.tourinews.es/uploads/s1/16/86/25/paisaje-2.jpeg"),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 10, left: 10),
                  child: Text(product.nombreProducto, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                )
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 10, left: 10),
                  child: Text("\$" + product.precio, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black54)),
                )
              )
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
        ),
      )
    );
  }
}