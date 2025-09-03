import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../services/local_storage.dart';
import '../services/notification_service.dart';
import '../services/auth_service.dart';

class Habit {
  String name;
  List<DateTime> completionDates;
  int streak;

  Habit({required this.name, this.completionDates = const [], this.streak = 0});

  void markComplete() {
    final today = DateTime.now();
    if (completionDates.isEmpty ||
        !isSameDay(completionDates.last, today.subtract(const Duration(days: 1)))) {
      streak = 1;
    } else {
      streak += 1;
    }
    completionDates.add(today);
  }

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Map<String, dynamic> toJson() => {
        'name': name,
        'completionDates': completionDates.map((d) => d.toIso8601String()).toList(),
        'streak': streak,
      };

  static Habit fromJson(Map<String, dynamic> json) {
    return Habit(
      name: json['name'],
      completionDates: (json['completionDates'] as List<dynamic>)
          .map((d) => DateTime.parse(d))
          .toList(),
      streak: json['streak'],
    );
  }
}

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  List<Habit> _habits = [];
  final NotificationService _notificationService = NotificationService();
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    loadHabits();
    _notificationService.init();
    LocalStorage.getTheme().then((value) => setState(() => _isDarkMode = value));
  }

  Future<void> loadHabits() async {
    final raw = await LocalStorage.getHabits();
    setState(() {
      _habits = raw.map((json) => Habit.fromJson(json)).toList();
    });
  }

  Future<void> saveHabits() async {
    await LocalStorage.saveHabits(_habits.map((h) => h.toJson()).toList());
  }

  void markHabitComplete(Habit habit) {
    setState(() {
      habit.markComplete();
    });
    saveHabits();
    _notificationService.scheduleDaily(
        habit.hashCode, 'Habit Reminder', 'Time for ${habit.name}', const Time(8, 0));
  }

  Future<void> addHabit() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Habit'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Habit name'),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    _habits.add(Habit(name: controller.text.trim()));
                  });
                  saveHabits();
                  Navigator.pop(context);
                }
              },
              child: const Text('Add')),
        ],
      ),
    );
  }

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    LocalStorage.saveTheme(_isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habits'),
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: addHabit,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _habits.length,
              itemBuilder: (context, index) {
                final habit = _habits[index];
                return ListTile(
                  title: Text('${habit.name} (Streak: ${habit.streak})'),
                  trailing: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () => markHabitComplete(habit),
                  ),
                );
              },
            ),
          ),
          TableCalendar(
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2030),
            focusedDay: DateTime.now(),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, _) {
                final completed = _habits.any((h) =>
                    h.completionDates.any((d) => h.isSameDay(d, day)));
                return Container(
                  decoration: BoxDecoration(
                    color: completed ? Colors.green : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(child: Text('${day.day}')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
