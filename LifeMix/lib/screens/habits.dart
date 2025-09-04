import 'package:flutter/material.dart';
import 'package:lifemix_app/services/local_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final LocalStorage _localStorage = LocalStorage();
  Map<String, dynamic> _streaks = {};

  @override
  void initState() {
    super.initState();
    _loadStreaks();
  }

  Future<void> _loadStreaks() async {
    final streaks = await _localStorage.getStreaks();
    setState(() {
      _streaks = streaks;
    });
  }

  Future<void> _incrementStreak(String habit) async {
    _streaks[habit] = (_streaks[habit] ?? 0) + 1;
    await _localStorage.saveStreaks(_streaks);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Habits")),
      body: ListView(
        children: _streaks.keys.map((habit) {
          return ListTile(
            title: Text(habit),
            subtitle: Text("Streak: ${_streaks[habit]} days"),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _incrementStreak(habit),
            ),
          );
        }).toList(),
      ),
    );
  }
}
