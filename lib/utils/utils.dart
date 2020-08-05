import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../models/profile.dart';
import '../models/orderitem.dart';

Future<List> fetchProducts() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.get("token");
  return http.post("http://192.168.1.75/WSPawy/ws_fetch_products.php", 
  body: jsonEncode(<String, String> {'token': token, 'option': 'product'}))
  .then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400) {
      throw new Exception("Error while fetching data");
    } else {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      return items.map((data) => Producto.fromJson(data)).toList();
    }
  });
}

Future<List> fetchProductsByID(String categoria) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.get("token");
  return http.post("http://192.168.1.75/WSPawy/ws_fetch_products.php", 
  body: jsonEncode(<String, String> {'token': token, 'categoria': categoria, 'option': 'productID'}))
  .then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400) {
      throw new Exception("Error while fetching data");
    } else {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      return items.map((data) => Producto.fromJson(data)).toList();
    }
  });
}


Future<List> fetchCategories() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.get("token");
  return http.post("http://192.168.1.75/WSPawy/ws_fetch_products.php", 
  body: jsonEncode(<String, String> {'token': token, 'option': 'category'}))
  .then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400) {
      throw new Exception("Error while fetching data");
    } else {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      return items.map((data) => Categoria.fromJson(data)).toList();
    }
  });
}

Future<Perfil> fetchProfileData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.get("token");
  return http.post("http://192.168.1.75/WSPawy/ws_fetch_profile_data.php", 
  body: jsonEncode(<String, String> {'token': token, 'option': 'profile'}))
  .then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400) {
      throw new Exception("Error while fetching data");
    } else {
      return Perfil.fromJson(json.decode(response.body));
    }
  });
}

Future<List<ItemOrden>> fetchOrderItems() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.get("token");
  return http.post("http://192.168.1.75/WSPawy/ws_fetch_profile_data.php", 
  body: jsonEncode(<String, String> {'token': token, 'option': 'orders'}))
  .then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400) {
      throw new Exception("Error while fetching data");
    } else {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<ItemOrden> list = List<ItemOrden>.from(items.map((data) => ItemOrden.fromJson(data)));
      return list;
    }
  });
}

Future<List> placeOrder(List data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var orderData = jsonEncode(data);
  var token = prefs.get("token");
  return http.post("http://192.168.1.75/WSPawy/ws_fetch_profile_data.php", 
  body: jsonEncode(<String, String> {'token': token, 
  'option': 'placeOrd', 
  'orderData': orderData
  }))
  .then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400) {
      throw new Exception("Error while fetching data");
    } else {
      print(response.body);
    }
  });
}