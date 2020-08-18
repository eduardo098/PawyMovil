import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  static String SERVER_URL = "http://192.168.1.67";
  String selectedDate = "";
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController birthDayController = new TextEditingController();
  String selectedGender = "";

  Item gender;
  List<Item> options = <Item> [
    const Item("Masculino"),
    const Item("Femenino"),
    const Item("Otro"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white30,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.greenAccent),
          onPressed: () => Navigator.of(context).pop(),
        ), 
      ),
      body: Padding(
        padding: EdgeInsets.only(top:60, left: 20, right: 20),
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
                  'Registrate',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre completo',
                ),
              ),
            ),
            Container(  
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                controller: birthDayController,
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  showDatePicker(
                    context: context,
                    initialDate:  DateTime.now(),
                    firstDate:
                          DateTime(1901),
                    lastDate:  DateTime.now().add( Duration(days: 30)),
                  ).then((date) {
                    String formattedDate = formatDate(date, [yyyy, '/', mm, '/', dd]);
                    selectedDate = formattedDate;
                    birthDayController.text = selectedDate;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Fecha de nacimiento',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: DropdownButton<Item>(    
                isExpanded: true,
                hint: Text("Genero"),
                value: gender,
                onChanged: (Item value) {
                  setState(() {
                    gender = value;
                  });
                },
                items: options.map((Item item) {
                  return  DropdownMenuItem<Item>(
                    value: item,
                    child: Row(
                      children: <Widget>[
                        Text(
                          item.name,
                          style:  TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              )
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Correo electrónico',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
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
                  child: Text('Registrate'),
                  onPressed: () {
                    if (nameController.text == '' || emailController.text == '' 
                      || passwordController.text == '') {
                        signUpDialog(context, 'Por favor, completa los campos.');
                    } else if(passwordController.text.length < 8) {
                      signUpDialog(context, 'La contraseña debe de contener al menos 8 caracteres.');
                    } else if(!passwordController.text.contains("@")) {
                      signUpDialog(context, 'Ingresa un correo válido.');
                    } else {
                      signUp(nameController.text, birthDayController.text, gender.name, emailController.text, passwordController.text);
                    }
                  },
                )),
          ],
        )
      )
    );
  }

  String _value = '';

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2019)
    );
    if(picked != null) setState(() => _value = picked.toString());
  }

  Future<String> signUp(String name, String birth, String gender, String email, String password) async {
    return http.post(SERVER_URL + "/WSPawy/ws_signup.php", body: jsonEncode(
      <String, String> 
      {'name': name, 'birth': birth, 'gender': gender, 'email': email, 'password': password}))
    .then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw new Exception("Error while fetching data");
      } else {
        //Map<String, dynamic> responseJson = json.decode(response.body);
        print(jsonDecode(response.body));
        Map<String, dynamic> responseJson = json.decode(response.body);
        int signupStatus = responseJson["status"];

        if (signupStatus == 1) {
          Navigator.of(context).pop();
        } else if (signupStatus == 2){
          signUpDialog(context, "El correo que elegiste está tomado");
        } else if(signupStatus == 0) {
          signUpDialog(context, "Ocurrio un error en el registro");
        } 
      }
    });
  }

  void signUpDialog(BuildContext context, String message) {
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


class Item {
  const Item(this.name);
  final String name;
}
