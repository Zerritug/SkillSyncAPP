import 'package:flutter/material.dart';
import 'package:skillsync/routing/route_names.dart';
import '../../db/SKDataBase.dart';
import '../../db/Models/Lesson.dart';
import 'package:go_router/go_router.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  State<LessonScreen> createState() => _LessonScreen();
}

class _LessonScreen extends State<LessonScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController categoryIdController = TextEditingController();
  bool state = false;

  Future<void> _addLesson() async {
    final db = await AppDatabase.initDB();
    await db.insert('lesson', {
      'title': titleController.text,
      'content': contentController.text,
      'date': dateController.text,
      'state': state ? 1 : 0,
      'user_id': int.tryParse(userIdController.text) ?? 0,
      'category_id': int.tryParse(categoryIdController.text) ?? 0,
    });
    titleController.clear();
    contentController.clear();
    dateController.clear();
    userIdController.clear();
    categoryIdController.clear();
    setState(() => state = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Lección agregada')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Lección')),
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
              controller: userIdController,
              decoration: const InputDecoration(labelText: 'ID Usuario'),
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
            ElevatedButton(onPressed: _addLesson, child: const Text('Guardar')),
            ElevatedButton(
              onPressed: () => context.go('/viewLessons'),
              child: const Text('Ver Lecciones'),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/mainmenu');
              },
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}
