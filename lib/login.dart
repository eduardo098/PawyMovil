import 'package:flutter/material.dart';
import 'package:pawyapp/signup.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  static String SERVER_URL = "http://192.168.1.67";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top:120, left: 20, right: 20),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Text(
                  'Pawy',
                  style: TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Text(
                  'Iniciar sesión',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Correo Electrónico',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contraseña',
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 50,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.greenAccent,
                  child: Text('Iniciar Sesión'),
                  onPressed: () {
                    login(context, emailController.text, passwordController.text);
                  },
                )),
            Container(
              child: Row(
                children: <Widget>[
                  Text('¿No tienes una cuenta?'),
                  FlatButton(
                    textColor: Colors.greenAccent,
                    child: Text(
                      'Registrate',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              )
            )
          ],
        )
      )
    );
  }

  Future<String> login(BuildContext context, String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      return await http.post(SERVER_URL + "/WSPawy/ws_login.php", 
      body: jsonEncode(<String, String> {'email': email, 'password': password}))
      .then((http.Response response) {
        print(jsonDecode(response.body));
        Map<String, dynamic> responseJson = json.decode(response.body);
        int loginStatus = responseJson["success"];

        if (loginStatus == 1) {
          print("Logeado!");
          loginDialog(context, "Has iniciado sesión con exito!");
          prefs.setString("token", responseJson["token"]);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyApp()),);
        } else {
          loginDialog(context, "Credenciales incorrectas.");
        }
      });
    } catch(e) {
      print(e);
      return null;
    }
  }

  void loginDialog(BuildContext context, String message) {
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
                child: Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
      }
    );
  }
}