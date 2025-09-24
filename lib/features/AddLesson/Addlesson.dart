import 'package:flutter/material.dart';
import 'package:skillsync/routing/route_names.dart';
import '../../db/SKDataBase.dart';
import '../../db/Models/Lesson.dart';
import 'package:go_router/go_router.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController categoryIdController = TextEditingController();
  bool state = false;

  List<Lesson> lessons = [];

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    final db = await AppDatabase.initDB();
    final result = await db.query('lesson');
    setState(() {
      lessons = result.map((e) => Lesson.fromMap(e)).toList();
    });
  }

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
    _loadLessons();
  }

  Future<void> _deleteLesson(int id) async {
    final db = await AppDatabase.initDB();
    await db.delete('lesson', where: 'id = ?', whereArgs: [id]);
    _loadLessons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lecciones')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
            ElevatedButton(onPressed: _addLesson, child: const Text('Agregar')),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                context.goNamed(RouteNames.mainMenu);
              },
              child: const Text('Volver'),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: lessons.length,
                itemBuilder: (_, index) {
                  final lesson = lessons[index];
                  return ListTile(
                    title: Text(lesson.title),
                    subtitle: Text(
                      'Estado: ${lesson.state ? "Completada" : "Pendiente"}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteLesson(lesson.id!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
