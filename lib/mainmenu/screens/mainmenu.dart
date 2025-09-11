import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillsync/core/constants.dart';
import 'package:skillsync/core/theme/text_styles.dart';
import 'package:skillsync/core/theme/app_colors.dart';
import 'package:skillsync/core/theme/app_layouts.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => MainMenuScreenState();
}

class MainMenuScreenState extends State<MainMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,

        title: Padding(
          padding: LayoutStyles.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('¡Hola, $userName', style: AppTextStyles.greeting),
              Text('Nivel de usuario: $level', style: AppTextStyles.userlevel),
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.tertiary,
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
            const SizedBox(height: 20),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.go('/mindmap');
                  },
                  child: const Text('MindMap'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
