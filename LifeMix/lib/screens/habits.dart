import 'package:flutter/material.dart';
import '../services/local_storage.dart';
import '../services/notification_service.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final LocalStorage _storage = LocalStorage();
  final NotificationService _notifications = NotificationService();

  List<String> _habits = [];

  @override
  void initState() {
    super.initState();
    _loadHabits();
    _notifications.init(); // Initialize notification service
  }

  Future<void> _loadHabits() async {
    final stored = await _storage.getHabits();
    setState(() {
      _habits = List<String>.from(stored ?? []);
    });
    _scheduleAllHabitNotifications();
  }

  Future<void> _addHabit(String habit) async {
    _habits.add(habit);
    await _storage.saveHabits(_habits);
    _scheduleNotificationForHabit(habit);
    setState(() {});
  }

  Future<void> _removeHabit(String habit, int index) async {
    _habits.removeAt(index);
    await _storage.saveHabits(_habits);
    await _notifications.cancelNotification(index); // Cancel by habit index
    setState(() {});
  }

  void _scheduleAllHabitNotifications() {
    for (int i = 0; i < _habits.length; i++) {
      _scheduleNotificationForHabit(_habits[i], id: i);
    }
  }

  void _scheduleNotificationForHabit(String habit, {int? id}) {
    final notificationId = id ?? _habits.indexOf(habit);
    _notifications.scheduleDaily(
      notificationId,
      'Habit Reminder',
      'Don\'t forget to complete: $habit',
      const Time(9, 0, 0), // Example: 9 AM daily reminder
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Habits')),
      body: ListView.builder(
        itemCount: _habits.length,
        itemBuilder: (context, index) {
          final habit = _habits[index];
          return ListTile(
            title: Text(habit),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _removeHabit(habit, index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newHabit = await _showAddHabitDialog();
          if (newHabit != null && newHabit.isNotEmpty) {
            _addHabit(newHabit);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<String?> _showAddHabitDialog() async {
    String? habitName;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Habit'),
        content: TextField(
          onChanged: (value) => habitName = value,
          decoration: const InputDecoration(hintText: 'Enter habit name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    return habitName;
  }
}
