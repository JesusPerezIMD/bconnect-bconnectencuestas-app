import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  static Future<String?> getString(String key) async {
    final preferencias = await prefs;
    return preferencias.getString(key);
  }

  static Future setString(String key, String value) async {
    final preferencias = await prefs;
    return preferencias.setString(key, value);
  }

  static Future<bool> getBool(String key) async {
    final preferencias = await prefs;
    return preferencias.getBool(key) ?? false;
  }

  static Future setBool(String key, bool value) async {
    final preferencias = await prefs;
    return preferencias.setBool(key, value);
  }

  static Future setListString(String key, List<String> value) async {
    final preferencias = await prefs;
    return preferencias.setStringList(key, value);
  }

  static Future<List<String>> getListString(String key) async {
    final preferencias = await prefs;
    return preferencias.getStringList(key) ?? [];
  }

  static Future<bool> remove(String key) async {
    final preferencias = await prefs;
    return preferencias.remove(key);
  }
}
