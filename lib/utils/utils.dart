import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../models/profile.dart';
import '../models/orderitem.dart';

const String SERVER_URL = "http://192.168.1.67";

Future<List> fetchProducts() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.get("token");
  try {
    return await http.post(SERVER_URL + "/WSPawy/ws_fetch_products.php", 
    body: jsonEncode(<String, String> {'token': token, 'option': 'product'}))
    .then((http.Response response) {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();
        return items.map((data) => Producto.fromJson(data)).toList();
    }).catchError((e) {
      print(e);
      return null;
    });
  } catch(e) {
    print(e);
    return null;
  }
}

Future<List> fetchProductsByID(String categoria) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.get("token");
  return http.post(SERVER_URL +  "/WSPawy/ws_fetch_products.php", 
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
  try {
    return await http.post(SERVER_URL +  "/WSPawy/ws_fetch_products.php", 
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
  } catch(e) {
    print(e);
    return null;
  }
}


Future<Perfil> fetchProfileData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.get("token");
  return http.post(SERVER_URL + "/WSPawy/ws_fetch_profile_data.php", 
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

Future<ItemOrden> fetchOrderDetails(String orderNumber) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.get("token");
  return http.post(SERVER_URL + "/WSPawy/ws_fetch_profile_data.php", 
  body: jsonEncode(<String, String> {'token': token, 'orderNumber': orderNumber, 'option': 'orderDetails'}))
  .then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400) {
      throw new Exception("Error while fetching data");
    } else {
      return ItemOrden.fromJson(json.decode(response.body));
    }
  });
}

Future<List<ItemOrden>> fetchOrderItems() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.get("token");
  return http.post(SERVER_URL + "/WSPawy/ws_fetch_profile_data.php", 
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

Future<String> placeOrder(List data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var orderData = jsonEncode(data);
  var token = prefs.get("token");
  return http.post(SERVER_URL + "/WSPawy/ws_fetch_profile_data.php", 
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
      var decodedData = json.decode(response.body);
      var ordenID = decodedData["idProducto"];
      return ordenID;
    }
  });
}

Future<bool> cancelOrder(List data, String idOrden) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var orderData = jsonEncode(data);
  var token = prefs.get("token");
  return http.post(SERVER_URL + "/WSPawy/ws_fetch_profile_data.php", 
  body: jsonEncode(<String, String> {'token': token, 
  'option': 'cancelOrdr', 
  'orderData': orderData,
  'orderNumber': idOrden,
  }))
  .then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400) {
      throw new Exception("Error while fetching data");
    } else {
      print(response.body);
      var decodedData = json.decode(response.body);
      return decodedData;
    }
  });
}

Future<bool> addComment(String comment, String idOrden) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.get("token");
  return http.post(SERVER_URL + "/WSPawy/ws_fetch_profile_data.php", 
  body: jsonEncode(<String, String> {'token': token, 
  'option': 'addComment', 
  'comment': comment,
  'orderNumber': idOrden,
  }))
  .then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400) {
      throw new Exception("Error while fetching data");
    } else {
      print(response.body);
      var decodedData = json.decode(response.body);
      return decodedData;
    }
  });
}