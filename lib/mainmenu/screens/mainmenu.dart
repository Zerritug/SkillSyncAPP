import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillsync/core/constants.dart';
import 'package:skillsync/core/theme/text_styles.dart';
import 'package:skillsync/core/theme/app_colors.dart';
import 'package:skillsync/core/theme/app_layouts.dart';
import 'package:skillsync/routing/route_names.dart';

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
          children: [
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Progreso General', style: AppTextStyles.greeting2),
                const SizedBox(width: 40),
                ElevatedButton(
                  onPressed: () {
                    context.go('/mindmap');
                  },
                  child: const Text('MindMap'),
                ),
                const SizedBox(height: 20),
              ],
            ),
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                color: AppColors.tertiary,
                border: Border.all(width: 0.5, color: AppColors.sixtiary),
                borderRadius: BorderRadius.circular(12),
              ),
              width: 350,
              height: 200,

              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "Machine Learning  $data1 %",
                      style: AppTextStyles.greeting2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "Bienestar Mental  $data2 %",
                      style: AppTextStyles.greeting2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "UX Design  $data3 %",
                      style: AppTextStyles.greeting2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                context.go('/addLessons');
              },
              child: const Text('Añadir Lecciones'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.go('/viewLessons'),
              child: const Text('Ver Lecciones'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                context.go('/addTopics');
              },
              child: const Text('Añadir Tema'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.go('/viewTopics');
              },
              child: const Text('Ver Temas'),
            ),
          ],
        ),
      ),
    );
  }
}
