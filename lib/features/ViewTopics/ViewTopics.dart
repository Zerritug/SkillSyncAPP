import 'package:skillsync/routing/route_names.dart';
import '../../db/SKDataBase.dart';
import '../../db/Models/Topic.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class TopicListScreen extends StatefulWidget {
  const TopicListScreen({super.key});
  @override
  State<TopicListScreen> createState() => _TopicListScreenState();
}

class _TopicListScreenState extends State<TopicListScreen> {
  List<Topic> topics = [];

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    final db = await AppDatabase.initDB();
    final result = await db.query('topic');
    setState(() {
      topics = result.map((e) => Topic.fromMap(e)).toList();
    });
  }

  Future<void> _deleteLesson(int id) async {
    final db = await AppDatabase.initDB();
    await db.delete('topic', where: 'id = ?', whereArgs: [id]);
    _loadTopics();
  }

  void _ShowEdit(Topic topic) {
    final titlectrl = TextEditingController(text: topic.title);
    final conentctrl = TextEditingController(text: topic.content);
    final datectrl = TextEditingController(text: topic.date);
    bool iscompleted = topic.state;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Editar Tema"),
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
                    decoration: InputDecoration(labelText: "Editar fecha"),
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
                    whereArgs: [topic.id],
                  );
                  Navigator.pop(context);
                  _loadTopics();
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
      appBar: AppBar(title: const Text('Lista de Temas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: topics.length,
                itemBuilder: (_, index) {
                  final topic = topics[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(topic.title),
                      subtitle: Text('Estado'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteLesson(topic.id!),
                          ),
                          const SizedBox(width: 20),
                          IconButton(
                            icon: const Icon(Icons.update),
                            onPressed: () => _ShowEdit(topic),
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
