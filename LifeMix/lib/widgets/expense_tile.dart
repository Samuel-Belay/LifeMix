import 'package:flutter/material.dart';

class ExpenseTile extends StatelessWidget {
  final String title;
  final double amount;
  const ExpenseTile({super.key, required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(title), trailing: Text('\$${amount.toStringAsFixed(2)}'));
  }
}
