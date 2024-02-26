class BCColaborador {
  String? sId;
  String? idOrigen;
  String? names;
  String? lastNames;
  String? email;
  String? phone;
  num? securityLevel;
  String? division;
  String? idcia;
  String? nombrecia;
  String? idsuc;
  String? nombresuc;
  String? iddepto;
  String? nombredepto;
  String? puesto;
  String? codemp;

  BCColaborador({
    this.sId,
    this.idOrigen,
    this.names,
    this.lastNames,
    this.email,
    this.phone,
    this.securityLevel,
    this.division,
    this.idcia,
    this.nombrecia,
    this.idsuc,
    this.nombresuc,
    this.iddepto,
    this.nombredepto,
    this.puesto,
    this.codemp,
  });

  BCColaborador.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    idOrigen = json['idOrigen'];
    names = json['names'];
    lastNames = json['lastNames'];
    email = json['email'];
    phone = json['phone'];
    securityLevel = json['securityLevel'];
    division = json['division'];
    idcia = json['idcia'];
    nombrecia = json['nombrecia'];
    idsuc = json['idsuc'];
    nombresuc = json['nombresuc'];
    iddepto = json['iddepto'];
    nombredepto = json['nombredepto'];
    puesto = json['puesto'];
    codemp = json['codemp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['idOrigen'] = idOrigen;
    data['names'] = names;
    data['lastNames'] = lastNames;
    data['email'] = email;
    data['phone'] = phone;
    data['securityLevel'] = securityLevel;
    data['division'] = division;
    data['idcia'] = idcia;
    data['nombrecia'] = nombrecia;
    data['idsuc'] = idsuc;
    data['nombresuc'] = nombresuc;
    data['iddepto'] = iddepto;
    data['nombredepto'] = nombredepto;
    data['puesto'] = puesto;
    data['codemp'] = codemp;
    return data;
  }
}
