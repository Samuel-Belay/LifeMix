import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifemix_app/theme/theme_notifier.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = ThemeNotifier();

    return ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => themeNotifier,
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: 'LifeMix App',
            theme: themeNotifier.getTheme(),
            home: const Scaffold(
              body: Center(child: Text("LifeMix App Home")),
            ),
          );
        },
      ),
    );
  }
}
