import 'package:flutter_test/flutter_test.dart';
import 'package:lifemix_app/main.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('App loads', (WidgetTester tester) async {
    await tester.pumpWidget(const LifeMixApp()); // use the correct root widget name
    await tester.pumpAndSettle();

    // You can check for the first screen's title, e.g., 'Tasks' or the Dashboard
    expect(find.text('Habits'), findsOneWidget); // Dashboard default tab is Habits
  });
}
