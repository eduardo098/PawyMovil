class ItemOrden {
  String id;
  String idOrden;
  String idProducto;
  String estadoOrden;
  String fechaCreacion;
  String precioUnitario;
  Null fechaEntrega;
  String comentarios;
  String cantidad;
  String nombreProducto;
  String imgUrl;
  String email;

  ItemOrden(
      {this.id,
      this.idOrden,
      this.estadoOrden,
      this.fechaCreacion,
      this.fechaEntrega,
      this.comentarios,
      this.cantidad,
      this.nombreProducto,
      this.imgUrl,
      this.email});

  ItemOrden.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idProducto = json['id_producto'];
    idOrden = json['id_orden'];
    estadoOrden = json['estado_orden'];
    fechaCreacion = json['fecha_creacion'];
    fechaEntrega = json['fecha_entrega'];
    comentarios = json['comentarios'];
    cantidad = json['cantidad'];
    nombreProducto = json['nombre_producto'];
    precioUnitario = json['precio_unitario'];
    imgUrl = json['img_url'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_producto'] = this.idProducto;
    data['id_orden'] = this.idOrden;
    data['estado_orden'] = this.estadoOrden;
    data['fecha_creacion'] = this.fechaCreacion;
    data['fecha_entrega'] = this.fechaEntrega;
    data['comentarios'] = this.comentarios;
    data['cantidad'] = this.cantidad;
    data['nombre_producto'] = this.nombreProducto;
    data['precio_unitario'] = this.precioUnitario;
    data['img_url'] = this.imgUrl;
    data['email'] = this.email;
    return data;
  }
}
