import 'package:pawyapp/localDB/db_helper.dart';

class Producto {
  String idProducto;
  String idLocal;
  String nombreProducto;
  String descProducto;
  String precio;
  String stock;
  String imgUrl;
  String categoria;
  String cantidad;

  Producto(
      {this.idProducto,
      this.nombreProducto,
      this.descProducto,
      this.precio,
      this.cantidad,
      this.stock,
      this.imgUrl,
      this.categoria});

  Producto.fromJson(Map<String, dynamic> json) {
    idProducto = json['id_producto'];
    nombreProducto = json['nombre_producto'];
    descProducto = json['desc_producto'];
    precio = json['precio'];
    stock = json['stock'];
    imgUrl = json['img_url'];
    categoria = json['categoria'];
  }

  Producto.fromMapTest(Map<String, dynamic> json) {
    idLocal = json['_id'].toString();
    idProducto = json['id_producto'].toString();
    nombreProducto = json['nombre_producto'];
    precio = json['precio'].toString();
    cantidad = json['cantidad'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_producto'] = this.idProducto;
    data['nombre_producto'] = this.nombreProducto;
    data['desc_producto'] = this.descProducto;
    data['precio'] = this.precio;
    data['stock'] = this.stock;
    data['img_url'] = this.imgUrl;
    data['categoria'] = this.categoria;
    return data;
  }

  Map<String, dynamic> toMapTest() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nombre_producto'] = this.nombreProducto;
    data['precio'] = double.parse(this.precio);
    data['cantidad'] = int.parse(this.cantidad);
    return data;
  }
}