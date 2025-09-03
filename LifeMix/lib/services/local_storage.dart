import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String habitsKey = 'habits';
  static const String themeKey = 'theme';

  /// Save habits list (list of maps).
  static Future<void> saveHabits(List<Map<String, dynamic>> habits) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(habitsKey, jsonEncode(habits));
  }

  /// Load habits list.
  static Future<List<Map<String, dynamic>>?> getHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(habitsKey);
    if (data != null) {
      final decoded = jsonDecode(data) as List;
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return null;
  }

  /// Save theme (light or dark).
  static Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(themeKey, isDark);
  }

  /// Load theme, default = light mode.
  static Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(themeKey) ?? false; // false = light
  }
}
