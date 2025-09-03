import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  final _notificationService = NotificationService();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadHabits();
    _notificationService.init();
  }

  Future<void> _loadHabits() async {
    final habits = await LocalStorage.getHabits() ?? <String>[];
    setState(() {
      _habits = habits.cast<String>(); // cast Object -> List<String>
    });
  }

  Future<void> _saveHabits() async {
    await LocalStorage.saveHabits(_habits);
  }

  void _addHabit(String habit) {
    final premiumService = context.read<PremiumService>();
    if (_habits.length >= 5 && !premiumService.isPremium) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upgrade to premium to add more habits')));
      return;
    }

    setState(() {
      _habits.add(habit);
    });
    _saveHabits();
    _notificationService.scheduleDaily(
        _habits.indexOf(habit),
        'Reminder',
        'Time to complete your habit: $habit',
        const Time(9, 0)); // Example time
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Habits')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _habits.length,
              itemBuilder: (context, index) {
                final habit = _habits[index];
                return ListTile(
                  title: Text(habit),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _habits.removeAt(index);
                      });
                      _saveHabits();
                    },
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
