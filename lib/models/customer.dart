import 'package:intl/intl.dart';

class Customer {
  String? id;
  String? fullName;
  num? latitude;
  num? longitude;
  String? address;
  String? stateCode;
  String? stateName;
  String? municipalityCode;
  String? municipalityName;
  String? colonyCode;
  String? colonyName;
  String? commercialBusinessCode;
  String? commercialBusinessName;
  num? distance;
  bool? centinela;
  bool? censado;
  String? ultimoCenso;
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  Customer(
      {this.id,
      this.fullName,
      this.latitude,
      this.longitude,
      this.address,
      this.stateCode,
      this.stateName,
      this.municipalityCode,
      this.municipalityName,
      this.colonyCode,
      this.colonyName,
      this.commercialBusinessCode,
      this.commercialBusinessName,
      this.distance,
      this.ultimoCenso,
      this.centinela}) {
    // Check if ultimoCenso is a date and it is today
    if (ultimoCenso != null) {
      try {
        String nowFormattedDate = formatter.format(DateTime.now().toUtc());
        String dateFormattedDate =
            formatter.format(DateTime.parse(ultimoCenso ?? ''));
        censado = nowFormattedDate == dateFormattedDate;
      } catch (e) {
        censado = false;
      }
    } else {
      censado = false;
    }
  }
  Customer.fromJson(Map<String, dynamic> json) {
    id = json['idcliente'];
    fullName = json['nomcliente'];
    address = json['direccion'];
    stateCode = json['estado'];
    stateName = json['nomestado'];
    municipalityCode = json['municipio'];
    municipalityName = json['nommunicipio'];
    colonyCode = json['colonia'];
    colonyName = json['nomcolonia'];
    commercialBusinessCode = json['giro'];
    commercialBusinessName = json['nomgiro'];
    ultimoCenso = json['ultimo_censo'];
    latitude = (json['latitud'] ?? '') == ''
        ? null
        : double.parse(json['latitud'].toString());
    longitude = (json['longitud'] ?? '') == ''
        ? null
        : double.parse(json['longitud'].toString());
    distance = (json['distancia_metros'] ?? '') == ''
        ? null
        : double.parse(json['distancia_metros'].toString());
    centinela = json['centinela'];
    // Check if ultimoCenso is a date and it is today
    if (ultimoCenso != null) {
      try {
        String nowFormattedDate = formatter.format(DateTime.now().toLocal());
        String dateFormattedDate =
            formatter.format(DateTime.parse(ultimoCenso ?? '').toLocal());
        censado = true; //nowFormattedDate == dateFormattedDate;
      } catch (e) {
        censado = false;
      }
    } else {
      censado = false;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idcliente'] = id;
    data['nomcliente'] = fullName;
    data['latitud'] = latitude;
    data['longitud'] = longitude;
    data['direccion'] = address;
    data['estado'] = stateCode;
    data['nomestado'] = stateName;
    data['municipio'] = municipalityCode;
    data['nommunicipio'] = municipalityName;
    data['colonia'] = colonyCode;
    data['nomcolonia'] = colonyName;
    data['giro'] = commercialBusinessCode;
    data['nomgiro'] = commercialBusinessName;
    data['distancia_metros'] = distance;
    data['centinela'] = centinela;
    data['ultimo_censo'] = ultimoCenso;
    data['censado'] = censado;
    return data;
  }
}
