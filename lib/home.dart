import 'package:flutter/material.dart';
import 'product_details.dart';
import 'utils/utils.dart';
import 'models/product.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List> _products;
  List content;
  @override
  void initState() {
    super.initState();
    _products = fetchProducts();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 60, left: 20),
                child: Text("Hola, Maria", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.greenAccent)),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 20, left: 20),
                child: Text("Productos destacados", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.greenAccent)), 
              ),
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
                      return featuredProductCard(content[index]);
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
            /*
            GridView.count(
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 4.0,
              shrinkWrap: true,
              crossAxisCount: 2,
              physics: ScrollPhysics(),
              children: <Widget>[
                featuredProductCard(),
                featuredProductCard(),
                featuredProductCard(),
                featuredProductCard(),
                featuredProductCard(),
                featuredProductCard(),
                featuredProductCard(),
                featuredProductCard()
              ],
            ) */
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
          nombre: producto.nombreProducto,
          descripcion: producto.descProducto,
          precio: producto.precio
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
                  child: Text(producto.nombreProducto, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                )
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 10, left: 10),
                  child: Text("\$"+producto.precio, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black54)),
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