import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  Future<void> saveData(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<Map<String, dynamic>> getStreaks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('streaks');
    if (data != null) {
      return Map<String, dynamic>.from(jsonDecode(data));
    }
    return {};
  }

  Future<void> saveStreaks(Map<String, dynamic> streaks) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('streaks', jsonEncode(streaks));
  }
}
