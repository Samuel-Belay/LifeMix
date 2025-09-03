import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorage {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static List<Map<String, dynamic>>? getHabits() {
    final String? raw = _prefs?.getString('habits');
    if (raw == null) return [];
    final List decoded = jsonDecode(raw);
    return decoded.cast<Map<String, dynamic>>();
  }

Future<void> updateStreak(String habit, bool completedToday) async {
  final streaks = await LocalStorage.getStreaks() ?? <String, int>{};
  if (completedToday) {
    streaks[habit] = (streaks[habit] ?? 0) + 1;
  } else {
    streaks[habit] = 0;
  }
  await LocalStorage.saveStreaks(streaks);
}
  
  static void saveHabits(List<Map<String, dynamic>> habits) {
    _prefs?.setString('habits', jsonEncode(habits));
  }

  static bool? getBool(String key) => _prefs?.getBool(key);

  static void setBool(String key, bool value) => _prefs?.setBool(key, value);
}

