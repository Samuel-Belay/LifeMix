import 'package:flutter/material.dart';
import '../services/local_storage.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({Key? key}) : super(key: key);

  @override
  _HabitsScreenState createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final LocalStorage _storage = LocalStorage();
  List<String> _habits = <String>[];

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final List<String> habits = await _storage.getHabits();
    setState(() {
      _habits = habits;
    });
  }

  Future<void> _addHabit(String habit) async {
    setState(() {
      _habits.add(habit);
    });
    await _storage.saveHabits(_habits);
  }

  Future<void> _removeHabit(int index) async {
    setState(() {
      _habits.removeAt(index);
    });
    await _storage.saveHabits(_habits);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Habits')),
      body: ListView.builder(
        itemCount: _habits.length,
        itemBuilder: (BuildContext context, int index) {
          final String habit = _habits[index];
          return ListTile(
            title: Text(habit),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _removeHabit(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final String? newHabit = await _showAddHabitDialog();
          if (newHabit != null && newHabit.isNotEmpty) {
            await _addHabit(newHabit);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<String?> _showAddHabitDialog() {
    final TextEditingController controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Add a Habit'),
        content: TextField(controller: controller),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
