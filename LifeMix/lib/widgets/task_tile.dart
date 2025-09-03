import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final String task;
  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(task));
  }
}
