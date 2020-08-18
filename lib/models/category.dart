class Categoria {
  String idCategoria;
  String nombre;
  String imgURL;

  Categoria({this.idCategoria, this.nombre, this.imgURL});

  Categoria.fromJson(Map<String, dynamic> json) {
    idCategoria = json['id_categoria'];
    nombre = json['nombre'];
    imgURL = json['imagen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_categoria'] = this.idCategoria;
    data['nombre'] = this.nombre;
    return data;
  }
}