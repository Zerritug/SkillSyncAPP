import 'package:flutter/material.dart';
import 'package:skillsync/routing/route_names.dart';
import '../../db/SKDataBase.dart';
import '../../db/Models/Lesson.dart';
import 'package:go_router/go_router.dart';


class LessonListScreen extends StatefulWidget {
  const LessonListScreen({super.key});

  @override
  State<LessonListScreen> createState() => _LessonListScreenState();
}

class _LessonListScreenState extends State<LessonListScreen> {
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

  Future<void> _deleteLesson(int id) async {
    final db = await AppDatabase.initDB();
    await db.delete('lesson', where: 'id = ?', whereArgs: [id]);
    _loadLessons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Lecciones')),
      body: ListView.builder(
        itemCount: lessons.length,
        itemBuilder: (_, index) {
          final lesson = lessons[index];
          return ListTile(
            title: Text(lesson.title),
            subtitle: Text('Estado: ${lesson.state ? "Completada" : "Pendiente"}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteLesson(lesson.id!),
            ),
          );
        },
      ),
    );
  }
}
