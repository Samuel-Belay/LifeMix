import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class RingProgress extends StatelessWidget {
  final double percent;
  final double size;
  final Color color;
  final Color backgroundColor;

  const RingProgress({
    super.key,
    required this.percent,
    required this.size,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: size,
      lineWidth: 8.0,
      percent: percent,
      progressColor: color,
      backgroundColor: backgroundColor,
      circularStrokeCap: CircularStrokeCap.round,
      center: Text('${(percent * 100).toStringAsFixed(0)}%'),
    );
  }
}
