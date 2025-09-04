import 'package:flutter/material.dart';
import 'package:lifemix_app/services/local_storage.dart';
import 'package:lifemix_app/services/notification_service.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  List<Map<String, dynamic>> _habits = [];
  Map<String, int> _streaks = {};

  @override
  void initState() {
    super.initState();
    _loadHabits();
    _loadStreaks();
  }

  Future<void> _loadHabits() async {
    final habits = await LocalStorage.loadHabits();
    setState(() => _habits = habits);
  }

  Future<void> _loadStreaks() async {
    final streaks = await LocalStorage.loadStreaks();
    setState(() => _streaks = streaks);
  }

  Future<void> _addHabit(String name) async {
    setState(() {
      _habits.add({'name': name, 'completed': false});
      _streaks[name] = 0;
    });
    await LocalStorage.saveHabits(_habits);
    await LocalStorage.saveStreaks(_streaks);

    // Schedule notification at 9 AM using TZDateTime
    final NotificationService service = NotificationService();
    await service.scheduleDaily(
      _habits.length, // unique ID
      'Habit Reminder',
      'Don’t forget: $name',
      const TimeOfDay(hour: 9, minute: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Habits')),
      body: ListView.builder(
        itemCount: _habits.length,
        itemBuilder: (context, index) {
          final habit = _habits[index];
          final streak = _streaks[habit['name']] ?? 0;
          return ListTile(
            title: Text(habit['name']),
            subtitle: Text('Streak: $streak days'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addHabit('New Habit'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
