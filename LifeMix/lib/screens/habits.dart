import 'package:flutter/material.dart';
import '../services/local_storage.dart';

class HabitsScreen extends StatefulWidget {
  @override
  _HabitsScreenState createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  List<String> habits = [];

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final stored = await LocalStorage.getHabits();
    setState(() {
      // ✅ Fix: cast to List<String>
      habits = List<String>.from(stored ?? []);
    });
  }

  Future<void> _addHabit(String habit) async {
    setState(() {
      habits.add(habit);
    });
    await LocalStorage.saveHabits(habits);
  }

  Future<void> _removeHabit(int index) async {
    setState(() {
      habits.removeAt(index);
    });
    await LocalStorage.saveHabits(habits);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habits'),
      ),
      body: ListView.builder(
        itemCount: habits.length,
        itemBuilder: (context, index) {
          final habit = habits[index];
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
