import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/local_storage.dart';
import '../services/notification_service.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  List<Map<String, dynamic>> habits = [];
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  void _loadHabits() {
    habits = LocalStorage.getHabits() ?? [];
    setState(() {});
  }

  void _saveHabits() {
    LocalStorage.saveHabits(habits);
  }

  void _toggleHabit(int index) {
    habits[index]['completed'] = !(habits[index]['completed'] ?? false);
    if (habits[index]['completed']) {
      habits[index]['streak'] = (habits[index]['streak'] ?? 0) + 1;
      NotificationService().scheduleDaily(
        index,
        'Habit Completed!',
        'You completed ${habits[index]['title']} today!',
        TimeOfDay.now(),
      );
    }
    _saveHabits();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Habits')),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: focusedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            selectedDayPredicate: (day) => isSameDay(selectedDay, day),
            onDaySelected: (day, focusedDayNew) {
              setState(() {
                selectedDay = day;
                focusedDay = focusedDayNew;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];
                return ListTile(
                  title: Text(habit['title']),
                  subtitle: Text('Streak: ${habit['streak'] ?? 0}'),
                  trailing: Checkbox(
                    value: habit['completed'] ?? false,
                    onChanged: (_) => _toggleHabit(index),
                  ),
                  onLongPress: () {
                    setState(() {
                      habits.removeAt(index);
                      _saveHabits();
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final titleController = TextEditingController();
          final result = await showDialog<String>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('New Habit'),
              content: TextField(controller: titleController),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, titleController.text),
                  child: const Text('Add'),
                ),
              ],
            ),
          );
          if (result != null && result.isNotEmpty) {
            habits.add({'title': result, 'completed': false, 'streak': 0});
            _saveHabits();
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
