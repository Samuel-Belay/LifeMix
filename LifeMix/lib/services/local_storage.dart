import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorage {
  static Future<void> saveHabits(List<Map<String, dynamic>> habits) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('habits', jsonEncode(habits));
  }

  static Future<List<Map<String, dynamic>>> getHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('habits');
    if (data != null) {
      final list = jsonDecode(data) as List<dynamic>;
      return list.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }

  static Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDark);
  }

  static Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkMode') ?? false;
  }
}
