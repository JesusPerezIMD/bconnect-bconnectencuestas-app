class Encuestas {
  int? orden;
  String? bc_encuestaId;
  String? bc_nombre;
  String? bc_url;

  Encuestas({
    this.orden, 
    this.bc_encuestaId, 
    this.bc_nombre, 
    this.bc_url});

  Encuestas.fromJson(Map<String, dynamic> json) {
    orden = json['bc_orden'];
    bc_encuestaId = json['bc_encuestaId'];
    bc_nombre = json['bc_nombre'];
    bc_url = json['bc_url'];
  }
}
