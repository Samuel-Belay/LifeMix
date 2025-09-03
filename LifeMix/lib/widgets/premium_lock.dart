import 'package:flutter/material.dart';

class PremiumLock extends StatelessWidget {
  const PremiumLock({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purpleAccent, width: 3),
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.withOpacity(0.7),
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.lock, color: Colors.white, size: 36),
    );
  }
}
