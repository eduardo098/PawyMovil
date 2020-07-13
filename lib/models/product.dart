class Producto {
  String idProducto;
  String nombreProducto;
  String descProducto;
  String precio;
  String stock;
  String imgUrl;
  String categoria;

  Producto(
      {this.idProducto,
      this.nombreProducto,
      this.descProducto,
      this.precio,
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
}