import 'package:flutter/material.dart';
import 'package:skillsync/routing/route_names.dart';
import '../../db/SKDataBase.dart';
import '../../db/Models/Lesson.dart';
import 'package:go_router/go_router.dart';

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
      appBar: AppBar(title: const Text('Agregar Tema')),
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
                const Text('Completada'),
                Checkbox(
                  value: isCompleted,
                  onChanged:
                      (val) => setState(() => isCompleted = val ?? false),
                ),
              ],
            ),

            ElevatedButton(onPressed: _addTopic, child: const Text('Guardar')),
            ElevatedButton(
              onPressed: () => context.go('/viewTopics'),
              child: const Text('Ver Temas'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/mainmenu'),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}
