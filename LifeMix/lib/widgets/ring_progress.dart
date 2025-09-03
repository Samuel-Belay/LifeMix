import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class RingProgress extends StatelessWidget {
  final double percent;
  const RingProgress({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(radius: 50, lineWidth: 8, percent: percent, center: Text('${(percent * 100).toInt()}%'), progressColor: Colors.purple, backgroundColor: Colors.grey.shade300);
  }
}
