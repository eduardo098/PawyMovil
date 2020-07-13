import 'package:flutter/material.dart';
import 'orders.dart';
import 'package:pawyapp/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'utils/utils.dart';
import 'models/profile.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<Perfil> _profile;
  List content;
  @override
  void initState() {
    super.initState();
    _profile = fetchProfileData();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Perfil>(
      future: _profile,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,            
                  child: Padding(
                    padding: EdgeInsets.only(top:80),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage("https://images.fastcompany.net/image/upload/w_596,c_limit,q_auto:best,f_auto/wp-cms/uploads/2019/09/i-1-inside-bumble-ceo-whitney-wolfe-herds-mission-to-build-the-female-internet-FA1019BUMB002.jpg")
                    )
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text(snapshot.data.nombreUsuario, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  height: 400,
                  width: MediaQuery.of(context).size.width - 20,
                  child: Card(
                    elevation: 5,
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                            child: Text("Mis Ordenes", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),)
                          )
                        ),
                        orderItem(),
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
                              child: Text("Ver más"),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            RaisedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                              },
                              child: Text("Login")
                            ),
                            RaisedButton(
                              onPressed: () {
                                logOut();
                              },
                              child: Text("Cerrar sesión")
                            ) 
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          );
        } else if(snapshot.hasError){
          return Center(child: Text("${snapshot.error}"));
        }
      }
    );
  }

  void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  Widget orderItem() {
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
                child: Text("ID de Orden: #4245353", style: TextStyle(fontWeight: FontWeight.w700),)
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
                        padding: EdgeInsets.only(top: 10, left: 20),
                        child: Text("Producto X", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700))
                      )
                    ),
                    Align(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text("\$99,99", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700))
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
}