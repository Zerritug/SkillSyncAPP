import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skillsync/core/theme/app_colors.dart';
import 'package:skillsync/routing/route_names.dart';
import '../../db/SKDataBase.dart';
import '../../db/Models/Lesson.dart';
import 'package:go_router/go_router.dart';
import 'package:skillsync/core/theme/app_layouts.dart';
import 'package:skillsync/core/theme/text_styles.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  State<LessonScreen> createState() => _LessonScreen();
}

class _LessonScreen extends State<LessonScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final TextEditingController categoryIdController = TextEditingController();

  bool state = false;

  Future<void> _addLesson() async {
    if (titleController.text.isEmpty ||
        contentController.text.isEmpty ||
        dateController.text.isEmpty ||
        categoryIdController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Faltan datos")));
      return;
    }

    final categoryId = int.tryParse(categoryIdController.text);
    if (categoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Id de categoria invalido")));
    }

    final db = await AppDatabase.initDB();
    final result = await db.query(
      'topic',
      where: 'id = ?',
      whereArgs: [categoryId],
    );

    if (result.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("El tema no existe")));
      return;
    }
    await db.insert('lesson', {
      'title': titleController.text,
      'content': contentController.text,
      'date': dateController.text,
      'state': state ? 1 : 0,

      'category_id': int.tryParse(categoryIdController.text) ?? 0,
    });
    titleController.clear();
    contentController.clear();
    dateController.clear();

    categoryIdController.clear();
    setState(() => state = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Lección agregada')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.eightiary,
        title: const Text('Agregar Lección', style: AppTextStyles.titlesW),
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
            TextField(
              controller: categoryIdController,
              decoration: const InputDecoration(labelText: 'ID Categoría'),
            ),
            Row(
              children: [
                const Text('Completada'),
                Checkbox(
                  value: state,
                  onChanged: (val) => setState(() => state = val ?? false),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _addLesson,
              style: ButtonStyles.elevatedbutton4,
              child: const Text('Guardar', style: AppTextStyles.button3),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () => context.go('/viewLessons'),
              style: ButtonStyles.elevatedbutton1,
              child: const Text('Ver Lecciones', style: AppTextStyles.button3),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                context.go('/mainmenu');
              },
              style: ButtonStyles.elevatedbutton3,
              child: const Text('Volver', style: AppTextStyles.button3),
            ),
          ],
        ),
      ),
    );
  }
}
