class SolicitudCapacitacion {
  String? solicituddecapacitacionid;
  String? name;
  String? colaboradorname;
  String? codemp;
  String? estatusname;
  String? capacitacion;
  String? competencias;
  String? aprobador1name;
  String? aprobador2name;
  double? inversion;
  double? gastosdeviaje;
  double? costocurso;
  DateTime? fechainicio;
  DateTime? fechafin;
  int? horasdecapacitacion;
  int? participantes;
  String? comentarioscapacitacion;
  String? siguienteAutorizador;
  int? statecode;
  DateTime? createdon;
  DateTime? modifiedon;

  SolicitudCapacitacion({
  this.solicituddecapacitacionid,
  this.name,
  this.colaboradorname,
  this.codemp,
  this.estatusname,
  this.capacitacion,
  this.competencias,
  this.aprobador1name,
  this.aprobador2name,
  this.inversion,
  this.gastosdeviaje,
  this.costocurso,
  this.fechainicio,
  this.fechafin,
  this.horasdecapacitacion,
  this.participantes,
  this.comentarioscapacitacion,
  this.siguienteAutorizador,
  this.statecode,
  DateTime? createdon,
  DateTime? modifiedon,
  });
  SolicitudCapacitacion.fromJson(Map<String, dynamic> json) {
    solicituddecapacitacionid = json['bc_solicituddecapacitacionid'];
    name = json['bc_name'];
    colaboradorname = json['bc_colaboradorname'];
    codemp = json['bc_codemp'];
    estatusname = json['bc_estatusname'];
    capacitacion = json['bc_capacitacion'];
    competencias = json['bc_competencias'];
    aprobador1name = json['bc_aprobador1name'];
    aprobador2name = json['bc_aprobador2name'];
    inversion = json['bc_inversion'];
    gastosdeviaje = json['bc_gastosdeviaje'];
    costocurso=json['bc_costocurso'];
    fechainicio = DateTime.parse(json['bc_fechainicio']);
    fechafin = DateTime.parse(json['bc_fechafin']);
    horasdecapacitacion = json['bc_horasdecapacitacion'];
    participantes = json['bc_participantes'];
    comentarioscapacitacion = json['bc_comentarioscapacitacion'];
    siguienteAutorizador=json['siguienteAutorizador'];
    statecode = json['statecode'];
    createdon = DateTime.parse(json['createdon']);
    modifiedon = DateTime.parse(json['modifiedon']);
  }
}
class ReglasSolicitudCapacitacion {
 
  String? name;
  String? valor;

  ReglasSolicitudCapacitacion({
  this.name,
  this.valor,
  DateTime? createdon,
  });

  ReglasSolicitudCapacitacion.fromJson(Map<String, dynamic> json) {
    name = json['bc_name'];
    valor = json['bc_valor'];
  }

}

class EstatusSolicitudCapacitacion {
 
  String? estatusname;
  String? comentario;
  String? autorizador;
  DateTime? createdon;

  EstatusSolicitudCapacitacion({
  this.estatusname,
  this.comentario,
  this.autorizador,
  DateTime? createdon
  });
  EstatusSolicitudCapacitacion.fromJson(Map<String, dynamic> json) {
   
    estatusname = json['bc_estatusname'];
    comentario = json['bc_comentario'];
    autorizador =json['bc_aprobadorname'];
    createdon = DateTime.parse(json['createdon']);
  }
}