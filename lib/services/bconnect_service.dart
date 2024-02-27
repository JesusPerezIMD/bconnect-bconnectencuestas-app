import 'dart:convert';
import 'package:bconnect_capacitacion/env.dart';
import 'package:bconnect_capacitacion/models/models.dart';
import 'package:http/http.dart' as http;

class BConnectService {
  String? token;
  String apiUrl = Environment().BCONNECT_API;
  String apiBitacora = Environment().BITACORA_API;

  BConnectService();

  Future<AuthUser?> authByAccessToken(String token) async {
    try {
      AuthUser? user;
      final response = await http.post(
          Uri.parse('$apiUrl/Auth/AuthByAccessToken'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(<String, String>{
            'access_token': token,
            'servicesId': Environment().SERVICE_ID
          }));
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        user = AuthUser.fromJson(result);
      }
      return user;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<AuthUserCode?> authByAccessCode(String code) async {
    try {
      AuthUserCode? userCode;
      final response = await http.post(Uri.parse('$apiUrl/Auth/AccessCode'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(<String, String>{
            'accessCode': code,
            'servicesId': Environment().SERVICE_ID
          }));
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        userCode = AuthUserCode.fromJson(result);
      }
      return userCode;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<BCColaborador?> getColaborador(String userId) async {
    try {
      BCColaborador? colaborador;
      final response = await http.get(
        Uri.parse('$apiUrl/Hub/Profiles/ColaboradorByUserId?userId=$userId'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        colaborador = BCColaborador.fromJson(result);
      }
      return colaborador;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<BCUser?> chechAccessToken(String token) async {
    try {
      BCUser? user;
      final response =
          await http.get(Uri.parse('$apiUrl/Auth/CheckAccessToken'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        user = BCUser.fromJson(result);
      }
      return user;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<FirebaseUser?> firebaseAuth(String token) async {
    try {
      FirebaseUser? firebaseUser;
      final response =
          await http.get(Uri.parse('$apiUrl/Auth/AuthUser'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        firebaseUser = FirebaseUser.fromJson(result);
      }
      return firebaseUser;
    } catch (e) {
      throw Exception(e);
    }
  }


  Future<List<Capacitacion>> getCapacitacion(String userid,String serviceName, String codemp) async {
    try {
      List<Capacitacion> capacitacion = [];
      final response = await http.get(
          Uri.parse('$apiUrl/Encuestas/getEncuestasbyDivService?userid=$userid&serviceName=$serviceName'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        for (var data in result) {
          capacitacion.add(Capacitacion.fromJson(data));
        }
      }
      return capacitacion;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<SolicitudCapacitacion>> getHistorySaludEncuestas(String codemp) async {
    try {
      List<SolicitudCapacitacion> capacitacion = [];
      final response = await http.get(
          Uri.parse('$apiUrl/EncuestaSalud/getHistorySaludEncuestas?codemp=$codemp'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        for (var data in result) {
          capacitacion.add(SolicitudCapacitacion.fromJson(data));
        }
      }
      return capacitacion;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String?> setBitacoraEncuesta(
      String? encuesta,
      String? division,
      String? compania,
      String? codemp,
      String? servicename,
      String? clienteid) async {
    try {
      String? id;
      final response = await http.post(Uri.parse(apiBitacora),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(<String, String>{
            'encuesta_value': encuesta!,
            'division_value': division!,
            'compania_value': compania!,
            'codemp_value': codemp!,
            'servicename_value': servicename!,
            'clienteid_value': clienteid!
          }));
      if (response.statusCode == 200) {
        final result = response.body;
        id = result;
      }
      return id;
    } catch (e) {
      throw Exception(e);
    }
  }

}
