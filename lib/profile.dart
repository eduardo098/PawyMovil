import 'package:flutter/material.dart';
import 'orders.dart';
import 'package:pawyapp/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'utils/utils.dart';
import 'models/profile.dart';
import 'localDB/db_helper.dart';
import 'models/orderitem.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<Perfil> _profile;
  Future<List> _orderItems;
  List content;
  @override
  void initState() {
    super.initState();
    _profile = fetchProfileData();
    _orderItems = fetchOrderItems();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Perfil>(
      future: _profile,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          return Container(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,            
                  child: Padding(
                    padding: EdgeInsets.only(top:80),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
                    )
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text(snapshot.data.nombreUsuario, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  height: 300,
                  width: MediaQuery.of(context).size.width - 20,
                  child: Card(
                    elevation: 5,
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                            child: Text("Opciones", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),)
                          )
                        ),
                        //orderItem(),
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: SizedBox(
                            height: 50,
                            width: 220,
                            child: RaisedButton(  
                              color: Colors.greenAccent,
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Orders()));
                              },
                              child: Text("Ver mis ordenes"),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: SizedBox(
                            height: 50,
                            width: 220,
                            child: RaisedButton(  
                              color: Colors.greenAccent,
                              onPressed: () {
                                logOut();
                              },
                              child: Text("Cerrar sesión"),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }
    );
  }

  void logOut() async {
    DatabaseHelper.db.deleteAllProducts();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  Widget orderItem() {
    return FutureBuilder<List>(
      future: _orderItems,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: 160,
            width: MediaQuery.of(context).size.width - 50,
            child: Card(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, left: 15),
                      child: Text("ID de Orden: " + snapshot.data.last.idOrden, style: TextStyle(fontWeight: FontWeight.w700),)
                    )
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 15, top: 10),
                        height: 100,
                        width: 130,
                        child: Image.network(
                        "https://www.tourinews.es/uploads/s1/16/86/25/paisaje-2.jpeg",
                        fit: BoxFit.cover,
                        )
                      ),
                      Column(
                        children: <Widget>[
                          Align(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10, left: 20, right: 15),
                              child: Text(snapshot.data.last.nombreProducto, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700))
                            )
                          ),
                          Align(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text("\$" + snapshot.data.last.nombreProducto, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700))
                            )
                          ),
                        ],
                      ),
                      Align(
                        child: Padding(
                            padding: EdgeInsets.only(top: 10, left: 20),
                            child: Text("Cantidad: 3", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))
                        )
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}