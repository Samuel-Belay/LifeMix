import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> saveData(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Save streaks
  static Future<void> saveStreaks(Map<String, int> streaks) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (final entry in streaks.entries) {
      await prefs.setInt('streak_${entry.key}', entry.value);
    }
  }

  // Load streaks
  static Future<Map<String, int>> getStreaks(List<String> habitIds) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, int> streaks = {};
    for (final id in habitIds) {
      streaks[id] = prefs.getInt('streak_$id') ?? 0;
    }
    return streaks;
  }
}
