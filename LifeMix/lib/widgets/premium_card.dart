import 'package:flutter/material.dart';
import 'premium_lock.dart';

class PremiumCard extends StatelessWidget {
  final String title;
  final bool locked;
  const PremiumCard({super.key, required this.title, this.locked = true});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          Container(height: 120, padding: const EdgeInsets.all(16), alignment: Alignment.centerLeft, child: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
          if (locked) const Positioned.fill(child: PremiumLock()),
        ],
      ),
    );
  }
}
