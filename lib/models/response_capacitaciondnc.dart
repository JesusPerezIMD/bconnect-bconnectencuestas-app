class SolicitudCapacitacionDNC {
  String? bc_dncsolicitudesid;
  String? bc_folio;
  String? bc_colaboradorsolicitudname;
  String? bc_codemp;
  String? bc_dncareaname;
  String? bc_dncoperativos;
  String? bc_dncadministrativos;
  String? bc_dncmandosmedios;
  String? bc_cursopuesto;
  String? bc_comentarios;
  String? bc_periodoname;
  DateTime? createdon;
  DateTime? modifiedon;

  SolicitudCapacitacionDNC({
    this.bc_dncsolicitudesid,
    this.bc_folio,
    this.bc_colaboradorsolicitudname,
    this.bc_codemp,
    this.bc_dncareaname,
    this.bc_dncoperativos,
    this.bc_dncadministrativos,
    this.bc_dncmandosmedios,
    this.bc_cursopuesto,
    this.bc_comentarios,
    this.bc_periodoname,
    this.createdon,
    this.modifiedon,
  });

  SolicitudCapacitacionDNC.fromJson(Map<String, dynamic> json) {
    bc_dncsolicitudesid = json['bc_dncsolicitudesid'];
    bc_folio = json['bc_folio'];
    bc_colaboradorsolicitudname = json['bc_colaboradorsolicitudname'];
    bc_codemp = json['bc_codemp'];
    bc_dncareaname = json['bc_dncareaname'];
    bc_dncoperativos = json['bc_dncoperativos'];
    bc_dncadministrativos = json['bc_dncadministrativos'];
    bc_dncmandosmedios = json['bc_dncmandosmedios'];
    bc_cursopuesto = json['bc_cursopuesto'];
    bc_comentarios = json['bc_comentarios'];
    bc_periodoname = json['bc_periodoname'];
    createdon = DateTime.parse(json['createdon']);
    modifiedon = DateTime.parse(json['modifiedon']);
  }
}
