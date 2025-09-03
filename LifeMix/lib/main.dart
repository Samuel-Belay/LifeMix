import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/habits.dart';
import 'services/auth_service.dart';
import 'services/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isDark = await LocalStorage.getTheme();
  runApp(MyApp(isDarkMode: isDark));
}

class MyApp extends StatelessWidget {
  final bool isDarkMode;
  const MyApp({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: Consumer<AuthService>(
        builder: (context, auth, _) {
          return MaterialApp(
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const HabitsScreen(),
          );
        },
      ),
    );
  }
}
