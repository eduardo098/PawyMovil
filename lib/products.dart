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
  String serverUrl = "http://192.168.1.67";
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
                      child: Text(widget.categoria, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.greenAccent)),
                    )
                  ),
                ],
              )
            ),
            FutureBuilder(
              future: _products,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.none){
                  //TODO: Show no internet pic.
                  return Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Image.asset("assets/images/no_internet.png", fit: BoxFit.fill),
                          height: 200
                        )
                      ],
                    )
                  );
                } else {
                  if (snapshot.hasData) {
                    var size = MediaQuery.of(context).size;

                    /*24 is for notification bar on Android*/
                    double cardWidth = MediaQuery.of(context).size.width / 3.3;
                    double cardHeight = MediaQuery.of(context).size.height / 9.6;
                    content = snapshot.data;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: cardHeight/cardWidth
                      ),
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: content.length,
                      itemBuilder: (BuildContext context, int index) {
                        return featuredProductCard(context, content[index]);
                      }
                    );
                  } else {
                    return Center(
                      child: Text("")
                    );
                  }
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
              Image.network(serverUrl + product.imgUrl,),
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