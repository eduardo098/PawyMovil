import 'package:flutter/material.dart';
import 'home.dart';
import 'profile.dart';
import 'categories.dart';
import 'cart.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pawyapp/utils/utils.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget { 
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    checkIsLogin();
  } 

  int currentTab = 0;

  final List<Widget> screens = [Home()];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Home();

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            //Right Tab Bar Icons
            bottomBarItem(Home(), Icon(Icons.home, size: 28, color: currentTab == 0 ? Colors.black87 : Colors.grey), 0),
            bottomBarItem(Categories(), Icon(Icons.nature, size: 28, color: currentTab == 1 ? Colors.black87 : Colors.grey), 1),
            bottomBarItem(Cart(), Icon(Icons.shopping_cart, size: 28, color: currentTab == 2 ? Colors.black87 : Colors.grey), 2),
            bottomBarItem(Profile(), Icon(Icons.people, size: 28, color: currentTab == 3 ? Colors.black87 : Colors.grey), 3),
          ],
        ),
      ),
    );
  }

  Widget bottomBarItem(Widget screen, Icon icon, int currentTabIndex) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: IconButton(
        icon: icon,
        onPressed: () {
          setState(() {
            currentScreen = screen;
            currentTab = currentTabIndex;
          });
        },
      ),
    );
  }

  void checkIsLogin() async {
    String _token = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("token");
    if (_token != "" && _token != null) {
      print("already login.");
    }
    else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => new Login()),
      );
    }
  }
}
