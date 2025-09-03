import 'package:flutter/material.dart';
import 'habits.dart';
import 'expenses.dart';
import 'premium_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HabitsScreen(),
    ExpensesScreen(),
    PremiumPage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: "Habits"),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: "Expenses"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Premium"),
        ],
      ),
    );
  }
}
