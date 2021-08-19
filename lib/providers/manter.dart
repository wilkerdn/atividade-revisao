import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Manter {
  static Future<void> salvarString(String key, String value) async {
    final preferencias = await SharedPreferences.getInstance();
    preferencias.setString(key, value);
  }

  static Future<void> salvarMap(String key, Map<String, dynamic> value) async {
    salvarString(key, json.encode(value));
  }

  static Future<String> getString(String key) async {
    final preferencias = await SharedPreferences.getInstance();
    return preferencias.getString(key);
  }

  static Future<Map<String, dynamic>> getMap(String key) async {
    try {
      Map<String, dynamic> map = json.decode(await getString(key));
      return map;
    } catch (_) {
      return null;
    }
  }

  static Future<bool> remove(String key) async {
    final preferencias = await SharedPreferences.getInstance();
    return preferencias.remove(key);
  }
}
