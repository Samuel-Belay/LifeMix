import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'habits.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService authService = context.watch<AuthService>();
    final user = authService.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          if (user != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await authService.signOut();
                // Optional: Navigate back to sign-in or reload UI
              },
            ),
        ],
      ),
      body: Center(
        child: user == null
            ? ElevatedButton(
                onPressed: () async => await authService.signIn(),
                child: const Text('Sign in with Google'),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (user.photoUrl != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl!),
                      radius: 40,
                    ),
                  const SizedBox(height: 16),
                  Text(
                    'Hello, ${user.displayName ?? user.email}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await authService.signOut();
                    },
                    child: const Text('Sign Out'),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HabitsScreen(),
                        ),
                      );
                    },
                    child: const Text('Go to Habits'),
                  ),
                ],
              ),
      ),
    );
  }
}
