import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/local_storage.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  List<Map<String, dynamic>> _habits = [];
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final habits = await LocalStorage.getHabits();
    setState(() {
      _habits = habits ?? [];
    });
  }

  Future<void> _saveHabits() async {
    await LocalStorage.saveHabits(_habits);
  }

  void _toggleHabitCompletion(int index, DateTime day) {
    final dateStr = day.toIso8601String().split("T").first;

    setState(() {
      final habit = _habits[index];
      List<String> completions =
          List<String>.from(habit['completions'] ?? <String>[]);

      if (completions.contains(dateStr)) {
        completions.remove(dateStr);
      } else {
        completions.add(dateStr);
      }

      habit['completions'] = completions;
      habit['streak'] = _calculateStreak(completions);
    });

    _saveHabits();
  }

  int _calculateStreak(List<String> completions) {
    completions.sort((a, b) => b.compareTo(a)); // sort desc
    int streak = 0;
    DateTime today = DateTime.now();

    for (String dateStr in completions) {
      DateTime d = DateTime.parse(dateStr);
      if (d == today.subtract(Duration(days: streak))) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  void _addHabit() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Habit"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    _habits.add({
                      'title': controller.text,
                      'completions': <String>[],
                      'streak': 0,
                    });
                  });
                  _saveHabits();
                }
                Navigator.pop(context);
              },
              child: const Text("Add"))
        ],
      ),
    );
  }

  void _toggleTheme() {
    final appState = MyApp.of(context);
    if (appState != null) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      appState.setTheme(isDark ? Brightness.light : Brightness.dark);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Habits"),
        actions: [
          IconButton(
              icon: const Icon(Icons.color_lens), onPressed: _toggleTheme),
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
                  title: Text(habit['title']),
                  subtitle: Text("🔥 Streak: ${habit['streak']} days"),
                  trailing: Checkbox(
                    value: (habit['completions'] ?? [])
                        .contains(_selectedDay.toIso8601String().split("T").first),
                    onChanged: (_) => _toggleHabitCompletion(index, _selectedDay),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                String dateStr = day.toIso8601String().split("T").first;
                bool completed = _habits.any((habit) =>
                    (habit['completions'] ?? []).contains(dateStr));

                if (completed) {
                  return Center(
                    child: Text(
                      "${day.day}🔥",
                      style: const TextStyle(color: Colors.green),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
        ],
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: _addHabit, child: const Icon(Icons.add)),
    );
  }
}
