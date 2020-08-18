import 'package:flutter/material.dart';
import 'product_details.dart';
import 'utils/utils.dart';
import 'models/product.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List> _products;
  List content;
  String serverUrl = "http://192.168.1.67";
  @override
  void initState() {
    super.initState();
    _products = fetchProducts();
  }
  @override
  Widget build(BuildContext context) {

    bool isConnected = true;

    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 60, left: 20),
                child: Text(isConnected ? "Inicio" : "", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.greenAccent)),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 20, left: 20),
                child: Text(isConnected ? "Productos destacados" : "", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.greenAccent)), 
              ),
            ),
            FutureBuilder(
              future: _products,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  content = snapshot.data;
                  /*24 is for notification bar on Android*/
                  double cardWidth = MediaQuery.of(context).size.width / 3.3;
                  double cardHeight = MediaQuery.of(context).size.height / 4.6;
                  content = snapshot.data;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio:  cardWidth / cardHeight,
                    ),
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 8,
                    itemBuilder: (BuildContext context, int index) {
                      return featuredProductCard(content[index]);
                    }
                  );
                } else {
                    return Align(alignment: Alignment.center, child: Center(child: CircularProgressIndicator()));
                  }
                }
            ),
          ],
        )
      )
    );
  }

  Widget featuredProductCard(Producto producto) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ProductDetails(
          producto: producto,
        )));
      },
      child: Container(
        child: Card(
          //semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            children: <Widget>[
              Image.network(serverUrl + producto.imgUrl),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 10, left: 10),
                  child: Text(producto.nombreProducto, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                )
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 10, left: 10),
                  child: Row(
                    children: <Widget>[
                      Text("Precio: ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black54)),
                      Text("\$"+producto.precio, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black87)),
                    ],
                  )
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