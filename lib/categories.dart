import 'package:flutter/material.dart';
import 'package:pawyapp/products.dart';
import './models/category.dart';
import 'utils/utils.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  Future<List> _category;
  List content;
  @override
  void initState() {
    super.initState();
    _category = fetchCategories();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 40, left: 25, bottom: 20),
              child: Text(
                'Categorias',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                  color: Colors.greenAccent,
                ),
              ),
            ),
            FutureBuilder(
              future: _category,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  content = snapshot.data;
                  return ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: content.length,
                    itemBuilder: (BuildContext context, int index){
                      return Padding(
                        padding: EdgeInsets.all(20),
                        child: categoriesItem(content[index])
                      );
                    }
                  );
                }
              }
            )
            /*
            ListView(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                categoriesItem(),
                categoriesItem(),
                categoriesItem(),
                categoriesItem(),
                categoriesItem(),
              ]
            )*/
          ],
        )
      );
  }

  Widget categoriesItem(Categoria categoria) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Products(categoria: categoria.nombre)));
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
          borderRadius: BorderRadius.only( 
            topLeft: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0)
          ),
          color: Colors.greenAccent,
        ),
        padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 5.0),
        height: 100,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            categoria.nombre,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)
          )
        )
      )
    );
  }
}