import 'package:flutter/material.dart';

class HabitTile extends StatelessWidget {
  final String title;
  final bool completed;
  final int streak;
  final VoidCallback onTap;

  const HabitTile(
      {super.key,
      required this.title,
      required this.completed,
      required this.streak,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text('Streak: $streak'),
      trailing: Icon(
        completed ? Icons.check_circle : Icons.circle_outlined,
        color: completed ? Colors.green : null,
      ),
      onTap: onTap,
    );
  }
}
