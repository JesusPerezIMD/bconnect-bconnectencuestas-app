class SolicitudCapacitacion {
  String? bc_bitacoraencuestaid;
  DateTime? createdon;
  int? statecode;
  String? statecodename;
  String? bc_name;
  String? bc_colaborador;
  String? bc_division;
  String? bc_compania;
  String? bc_servicio;
  String? bc_servicioname;
  String? bc_encuesta;
  String? bc_encuestaname;
  String? bc_cliente;
  DateTime? bc_inicio;
  DateTime? bc_fin;
  String? bc_respuestaencuesta;
  String? bc_respuestaencuestaname;
  int? bc_finalizado;
  String? bc_finalizadoname;
  String? bc_folio;

  SolicitudCapacitacion({
    required this.bc_bitacoraencuestaid,
    required this.createdon,
    required this.statecode,
    required this.statecodename,
    required this.bc_name,
    required this.bc_colaborador,
    required this.bc_division,
    required this.bc_compania,
    required this.bc_servicio,
    required this.bc_servicioname,
    required this.bc_encuesta,
    required this.bc_encuestaname,
    required this.bc_cliente,
    required this.bc_inicio,
    required this.bc_fin,
    required this.bc_respuestaencuesta,
    required this.bc_respuestaencuestaname,
    required this.bc_finalizado,
    required this.bc_finalizadoname,
    required this.bc_folio,
  });
  SolicitudCapacitacion.fromJson(Map<String, dynamic> json) {
      bc_bitacoraencuestaid = json['bc_bitacoraencuestaid'] ?? '';
      createdon = json['createdon'] != null ? DateTime.parse(json['createdon']) : null;
      statecode = json['statecode'] ?? 0;
      statecodename = json['statecodename'] ?? '';
      bc_name = json['bc_name'] ?? '';
      bc_colaborador = json['bc_colaborador'] ?? '';
      bc_division = json['bc_division'] ?? '';
      bc_compania = json['bc_compania'] ?? '';
      bc_servicio = json['bc_servicio'] ?? '';
      bc_servicioname = json['bc_servicioname'] ?? '';
      bc_encuesta = json['bc_encuesta'] ?? '';
      bc_encuestaname = json['bc_encuestaname'] ?? '';
      bc_cliente = json['bc_cliente'] ?? '';
      bc_inicio = json['bc_inicio'] != null ? DateTime.parse(json['bc_inicio']) : null;
      bc_fin = json['bc_fin'] != null ? DateTime.parse(json['bc_fin']) : null;
      bc_respuestaencuesta = json['bc_respuestaencuesta'] ?? '';
      bc_respuestaencuestaname = json['bc_respuestaencuestaname'] ?? '';
      bc_finalizado = json['bc_finalizado'] ?? 0;
      bc_finalizadoname = json['bc_finalizadoname'] ?? '';
      bc_folio = json['bc_folio'] ?? '';
  }
}
