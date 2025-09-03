import 'package:flutter/material.dart';
import 'package:lifemix_app/services/local_storage.dart';
import 'package:table_calendar/table_calendar.dart';

class HabitsPage extends StatefulWidget {
  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  final List<String> _habits = ['Meditation', 'Workout', 'Reading'];
  Map<String, int> _streaks = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _loadStreaks();
  }

  Future<void> _loadStreaks() async {
    final streaks = await LocalStorage.getStreaks(_habits);
    setState(() {
      _streaks = streaks;
    });
  }

  Future<void> _incrementStreak(String habit) async {
    setState(() {
      _streaks[habit] = (_streaks[habit] ?? 0) + 1;
    });
    await LocalStorage.saveStreaks(_streaks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Habits')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _habits.length,
              itemBuilder: (context, index) {
                final habit = _habits[index];
                return ListTile(
                  title: Text(habit),
                  subtitle: Text('Streak: ${_streaks[habit] ?? 0} days'),
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => _incrementStreak(habit),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
