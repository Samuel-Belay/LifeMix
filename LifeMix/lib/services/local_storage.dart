import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _habitsKey = 'habits';
  static const String _streaksKey = 'streaks';

  /// Save habits
  static Future<void> saveHabits(List<Map<String, dynamic>> habits) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(habits);
    await prefs.setString(_habitsKey, encoded);
  }

  /// Load habits
  static Future<List<Map<String, dynamic>>> loadHabits() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? encoded = prefs.getString(_habitsKey);
    if (encoded == null) return [];
    final List<dynamic> decoded = jsonDecode(encoded);
    return decoded.cast<Map<String, dynamic>>();
  }

  /// Save streaks
  static Future<void> saveStreaks(Map<String, int> streaks) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(streaks);
    await prefs.setString(_streaksKey, encoded);
  }

  /// Load streaks
  static Future<Map<String, int>> loadStreaks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? encoded = prefs.getString(_streaksKey);
    if (encoded == null) return {};
    final Map<String, dynamic> decoded = jsonDecode(encoded);
    return decoded.map((key, value) => MapEntry(key, value as int));
  }
}
