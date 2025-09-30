import 'package:flutter/material.dart';

import '../../db/SKDataBase.dart';

import 'package:go_router/go_router.dart';
import 'package:skillsync/core/theme/app_layouts.dart';
import 'package:skillsync/core/theme/text_styles.dart';
import "package:skillsync/core/theme/app_colors.dart";

class TopicScreen extends StatefulWidget {
  const TopicScreen({super.key});

  @override
  State<TopicScreen> createState() => _TopicScreen();
}

class _TopicScreen extends State<TopicScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  bool isCompleted = false;

  Future<void> _addTopic() async {
    if (titleController.text.isEmpty ||
        contentController.text.isEmpty ||
        dateController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Faltan datos")));
    }
    final db = await AppDatabase.initDB();
    await db.insert('topic', {
      'title': titleController.text,
      'content': contentController.text,
      'date': dateController.text,
      'state': isCompleted ? 1 : 0,
    });
    titleController.clear();
    contentController.clear();
    dateController.clear();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Tema agregado')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Tema'),
        backgroundColor: AppColors.boldcolor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Contenido'),
            ),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Fecha'),
            ),

            Row(
              children: [
                const Text('Completado'),
                Checkbox(
                  value: isCompleted,
                  onChanged:
                      (val) => setState(() => isCompleted = val ?? false),
                ),
              ],
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: _addTopic,
              style: ButtonStyles.elevatedbutton4,
              child: const Text('Guardar', style: AppTextStyles.button3),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () => context.go('/viewTopics'),
              style: ButtonStyles.elevatedbutton1,
              child: const Text('Ver Temas', style: AppTextStyles.button3),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () => context.go('/mainmenu'),
              style: ButtonStyles.elevatedbutton3,
              child: const Text('Volver', style: AppTextStyles.button3),
            ),
          ],
        ),
      ),
    );
  }
}
