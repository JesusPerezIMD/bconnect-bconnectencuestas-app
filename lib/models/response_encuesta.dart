class SolicitudCapacitacion {
  int? crd52_responseencuestaid;
  DateTime? createdon;
  int? statecode;
  String? crd52_nombre;
  String? bp_compania;
  String? bp_division;
  String? bp_colaborador;
  String? bp_colaboradorname;
  String? bp_jsonresponse;
  String? bp_folio;
  String? bp_codemp;

  SolicitudCapacitacion({
    this.crd52_responseencuestaid,
    this.createdon,
    this.statecode,
    this.crd52_nombre,
    this.bp_compania,
    this.bp_division,
    this.bp_colaborador,
    this.bp_colaboradorname,
    this.bp_jsonresponse,
    this.bp_folio,
    this.bp_codemp,
  });
  SolicitudCapacitacion.fromJson(Map<String, dynamic> json) {
    crd52_responseencuestaid = json['crd52_responseencuestaid'];
    createdon = DateTime.parse(json['createdon']);
    statecode = json['statecode'];
    crd52_nombre = json['crd52_nombre'];
    bp_compania = json['bp_compania'];
    bp_division = json['bp_division'];
    bp_colaborador = json['bp_colaborador'];
    bp_colaboradorname = json['bp_colaboradorname'];
    bp_jsonresponse = json['bp_jsonresponse'];
    bp_folio = json['bp_folio'];
    bp_codemp = json['bp_codemp'];
  }
}
