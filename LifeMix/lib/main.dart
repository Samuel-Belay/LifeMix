import 'package:flutter/material.dart';
import 'screens/habits.dart';
import 'services/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isDark = await LocalStorage.getTheme();
  runApp(MyApp(initialBrightness: isDark ? Brightness.dark : Brightness.light));
}

class MyApp extends StatefulWidget {
  final Brightness initialBrightness;
  const MyApp({super.key, required this.initialBrightness});

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Brightness _brightness;

  @override
  void initState() {
    super.initState();
    _brightness = widget.initialBrightness;
  }

  void setTheme(Brightness brightness) {
    setState(() {
      _brightness = brightness;
    });
    LocalStorage.saveTheme(brightness == Brightness.dark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeMix App',
      theme: ThemeData(
        brightness: _brightness,
        primarySwatch: Colors.blue,
      ),
      home: HabitsScreen(),
    );
  }
}
