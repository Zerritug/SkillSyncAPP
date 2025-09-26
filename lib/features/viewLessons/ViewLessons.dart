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

  void _ShowEdit(Lesson lesson) {
    final titlectrl = TextEditingController(text: lesson.title);
    final conentctrl = TextEditingController(text: lesson.content);
    final datectrl = TextEditingController(text: lesson.date);
    final useridctrl = TextEditingController(text: lesson.userId.toString());
    final categoryidctrl = TextEditingController(
      text: lesson.categoryId.toString(),
    );
    bool iscompleted = lesson.state;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Editar Leccion"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: titlectrl,
                    decoration: const InputDecoration(
                      labelText: "Editar Titulo",
                    ),
                  ),
                  TextField(
                    controller: conentctrl,
                    decoration: const InputDecoration(
                      labelText: "Editar contenido",
                    ),
                  ),
                  TextField(
                    controller: datectrl,
                    decoration: InputDecoration(labelText: "Editar Fecha"),
                  ),
                  TextField(
                    controller: useridctrl,
                    decoration: InputDecoration(
                      label: Text("Editar Id De Usario"),
                    ),
                  ),
                  TextField(
                    controller: categoryidctrl,
                    decoration: InputDecoration(
                      label: Text("Editar Id De Categoria"),
                    ),
                  ),
                  Row(
                    children: [
                      const Text("Completado"),
                      Checkbox(
                        value: iscompleted,
                        onChanged:
                            (val) => setState(() => iscompleted = val ?? false),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  final db = await AppDatabase.initDB();
                  await db.update(
                    'topic',
                    {
                      'title': titlectrl.text,
                      'content': conentctrl.text,
                      'date': datectrl.text,
                    },
                    where: 'id = ?',
                    whereArgs: [lesson.id],
                  );
                  Navigator.pop(context);
                  _loadLessons();
                },
                child: const Text("Guardar"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('cancelar'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Lecciones')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: lessons.length,
                itemBuilder: (_, index) {
                  final lesson = lessons[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(lesson.title),
                      subtitle: Text(
                        'Estado: ${lesson.state ? "Completada" : "Pendiente"}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteLesson(lesson.id!),
                          ),
                          IconButton(
                            icon: const Icon(Icons.update),
                            onPressed: () => _ShowEdit(lesson),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
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
