import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/local_storage.dart';

class HabitsScreen extends StatefulWidget {
  @override
  _HabitsScreenState createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  List<Map<String, dynamic>> habits = []; // ✅ Each habit has name + streak + log
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final stored = await LocalStorage.getHabits();
    setState(() {
      habits = stored != null ? List<Map<String, dynamic>>.from(stored) : [];
    });
  }

  Future<void> _saveHabits() async {
    await LocalStorage.saveHabits(habits);
  }

  Future<void> _addHabit(String habit) async {
    setState(() {
      habits.add({
        'name': habit,
        'streak': 0,
        'lastCompleted': null,
        'log': <String>[],
      });
    });
    _saveHabits();
  }

  Future<void> _removeHabit(int index) async {
    setState(() {
      habits.removeAt(index);
    });
    _saveHabits();
  }

  void _toggleCompletion(int index) {
    final today = DateTime.now();
    final habit = habits[index];
    final lastCompleted = habit['lastCompleted'] != null
        ? DateTime.parse(habit['lastCompleted'])
        : null;

    if (lastCompleted != null &&
        lastCompleted.year == today.year &&
        lastCompleted.month == today.month &&
        lastCompleted.day == today.day) {
      // Already completed today → undo
      setState(() {
        habit['streak'] = (habit['streak'] > 0) ? habit['streak'] - 1 : 0;
        habit['lastCompleted'] = null;
        (habit['log'] as List).remove(today.toIso8601String());
      });
    } else {
      // Mark as completed
      setState(() {
        if (lastCompleted != null &&
            lastCompleted.add(const Duration(days: 1)).day == today.day) {
          habit['streak'] += 1; // Consecutive day → increase streak
        } else {
          habit['streak'] = 1; // Reset streak
        }
        habit['lastCompleted'] = today.toIso8601String();
        (habit['log'] as List).add(today.toIso8601String());
      });
    }

    _saveHabits();
  }

  bool _isCompletedOnDate(Map<String, dynamic> habit, DateTime date) {
    return (habit['log'] as List).any((d) {
      final logged = DateTime.parse(d);
      return logged.year == date.year &&
          logged.month == date.month &&
          logged.day == date.day;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habits'),
        actions: [
          IconButton(
            icon: Icon(
              theme.brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              // Toggle theme using inherited widget (implemented in main.dart)
              final brightness =
                  theme.brightness == Brightness.dark ? Brightness.light : Brightness.dark;
              MyApp.of(context)?.setTheme(brightness);
            },
          )
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];
                final name = habit['name'];
                final streak = habit['streak'];
                final completedToday = _isCompletedOnDate(habit, _selectedDay);

                return Card(
                  child: ListTile(
                    title: Text(name),
                    subtitle: Text("Streak: $streak 🔥"),
                    trailing: IconButton(
                      icon: Icon(
                        completedToday
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: completedToday ? Colors.green : null,
                      ),
                      onPressed: () => _toggleCompletion(index),
                    ),
                    onLongPress: () => _removeHabit(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final controller = TextEditingController();
          final result = await showDialog<String>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('New Habit'),
              content: TextField(controller: controller),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, controller.text),
                  child: const Text('Add'),
                ),
              ],
            ),
          );
          if (result != null && result.isNotEmpty) {
            _addHabit(result);
          }
        },
      ),
    );
  }
}
