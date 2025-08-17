import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Main Menu'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go('/welcome');
              },
              child: const Text('Go to Welcome Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
