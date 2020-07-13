class Categoria {
  String idCategoria;
  String nombre;

  Categoria({this.idCategoria, this.nombre});

  Categoria.fromJson(Map<String, dynamic> json) {
    idCategoria = json['id_categoria'];
    nombre = json['nombre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_categoria'] = this.idCategoria;
    data['nombre'] = this.nombre;
    return data;
  }
}