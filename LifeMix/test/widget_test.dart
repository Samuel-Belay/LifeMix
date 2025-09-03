import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifemix_app/main.dart'; // Ensure your main.dart has a class LifeMixApp

void main() {
  testWidgets('App smoke test', (tester) async {
    await tester.pumpWidget(const LifeMixApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
