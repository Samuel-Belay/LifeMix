import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _habitsKey = 'habits';

  /// Save the list of habits persistently.
  Future<void> saveHabits(List<String> habits) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_habitsKey, habits);
  }

  /// Retrieve the list of habits from persistent storage.
  Future<List<String>> getHabits() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_habitsKey) ?? <String>[];
  }
}
