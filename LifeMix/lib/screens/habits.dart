import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../services/local_storage.dart';
import '../services/premium_service.dart';
import '../services/notification_service.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  late List<String> _habits;
  Map<String, int> _streaks = {};
  final _notificationService = NotificationService();
  final _controller = TextEditingController();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadHabits();
    _notificationService.init();
  }

  Future<void> _loadHabits() async {
    final habits = await LocalStorage.getHabits() ?? <String>[];
    final streaks = await LocalStorage.getStreaks() ?? <String, int>{};
    setState(() {
      _habits = habits.cast<String>();
      _streaks = streaks.cast<String, int>();
    });
  }

  Future<void> _saveHabits() async {
    await LocalStorage.saveHabits(_habits);
  }

  Future<void> _updateStreak(String habit, bool completedToday) async {
    if (completedToday) {
      _streaks[habit] = (_streaks[habit] ?? 0) + 1;
    } else {
      _streaks[habit] = 0;
    }
    await LocalStorage.saveStreaks(_streaks);
    setState(() {});
  }

  void _addHabit(String habit) {
    final premiumService = context.read<PremiumService>();
    if (_habits.length >= 5 && !premiumService.isPremium) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upgrade to premium to add more habits')),
      );
      return;
    }

    setState(() {
      _habits.add(habit);
      _streaks[habit] = 0;
    });
    _saveHabits();
    _notificationService.scheduleDaily(
      _habits.indexOf(habit),
      'Reminder',
      'Time to complete your habit: $habit',
      const Time(9, 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Habits')),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: TableCalendar(
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              eventLoader: (day) {
                // Optionally, you can show which habits were done today
                return _habits;
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: _habits.length,
              itemBuilder: (context, index) {
                final habit = _habits[index];
                final streak = _streaks[habit] ?? 0;
                return ListTile(
                  title: Text('$habit (Streak: $streak)'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () => _updateStreak(habit, true),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => _updateStreak(habit, false),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _habits.removeAt(index);
                            _streaks.remove(habit);
                          });
                          _saveHabits();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Add habit'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _addHabit(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
