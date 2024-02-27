// ignore_for_file: non_constant_identifier_names
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;

class Environment {
  final GOOGLE_MAP_API_KEY = "AIzaSyDedLDHWHo6oEILIO5ycJYsv6dATa-Aaf8";

  //Local
  final BCONNECT_API = "http://localhost:17330";
  // final ALIADOS_API = 'https://localhost:44376/api';
  // final UrlApiImages = 'https://localhost:44376/';
  // final TWILIO_API = 'http://localhost:7071/api';
  // final WHATSAPP_NUMBER = "15165185350";

  //Test
  //final BCONNECT_API = "https://bconnectapitest.azurewebsites.net";
  final ALIADOS_API = 'https://bconnect-aliados-api.azurewebsites.net/api';
  final UrlApiImages = 'https://bconnect-aliados-api.azurewebsites.net/';
  final TWILIO_API = 'https://twiliofunctionbconnect.azurewebsites.net/api';
  final WHATSAPP_NUMBER = "15165185350";
  final BITACORA_API =
      "https://prod-45.westus.logic.azure.com:443/workflows/eb24003a3e604314ab801a7dea5ced7c/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=pxQuFcqDl6DjWQ-I1m2hzzwi1e1fbt_X5gFNObncOts";
  
  //Production
  // final BCONNECT_API = "https://bconnect-auth-api.azurewebsites.net";
  // final ALIADOS_API = 'https://bconnect-aliados-api-prod.azurewebsites.net/api';
  // final UrlApiImages = 'https://bconnect-aliados-api-prod.azurewebsites.net/';
  // final TWILIO_API = 'https://bconnect-twilio-function.azurewebsites.net/api';
  // final WHATSAPP_NUMBER = "5219993991528";
  
  final DEFAULT_LOCATION = const gm.LatLng(20.968147, -89.629872);
  final SERVICE_ID = "34542C82-6659-4DA3-804B-1B62FB44EDSA"; //capacitacion
  final SERVICE_NAME="BConnect Encuestas";

  static final Environment _environment = Environment._internal();

  factory Environment() {
    return _environment;
  }

  Environment._internal();
}
