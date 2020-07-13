class Perfil {
  String idUsuario;
  String nombreUsuario;
  String fechaNacimiento;
  String fechaCreacion;
  String genero;
  String email;
  String tipoUsuario;

  Perfil(
      {this.idUsuario,
      this.nombreUsuario,
      this.fechaNacimiento,
      this.fechaCreacion,
      this.genero,
      this.email,
      this.tipoUsuario});

  Perfil.fromJson(Map<String, dynamic> json) {
    idUsuario = json['id_usuario'];
    nombreUsuario = json['nombre_usuario'];
    fechaNacimiento = json['fecha_nacimiento'];
    fechaCreacion = json['fecha_creacion'];
    genero = json['genero'];
    email = json['email'];
    tipoUsuario = json['tipo_usuario'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_usuario'] = this.idUsuario;
    data['nombre_usuario'] = this.nombreUsuario;
    data['fecha_nacimiento'] = this.fechaNacimiento;
    data['fecha_creacion'] = this.fechaCreacion;
    data['genero'] = this.genero;
    data['email'] = this.email;
    data['tipo_usuario'] = this.tipoUsuario;
    return data;
  }
}
