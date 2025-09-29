import '../../db/SKDataBase.dart';
import '../../db/Models/Topic.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:skillsync/core/theme/app_layouts.dart';
import 'package:skillsync/core/theme/text_styles.dart';
import "package:skillsync/core/theme/app_colors.dart";
import 'package:intl/intl.dart';

class TopicListScreen extends StatefulWidget {
  const TopicListScreen({super.key});
  @override
  State<TopicListScreen> createState() => _TopicListScreenState();
}

class _TopicListScreenState extends State<TopicListScreen> {
  List<Topic> topics = [];
  final TextEditingController datecontroller = TextEditingController();
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

  Future<void> _searchbydate(String date) async {
    final db = await AppDatabase.initDB();
    final result = await db.query(
      'topic',
      where: 'date = ?',
      whereArgs: [date],
    );
    setState(() {
      topics = result.map((e) => Topic.fromMap(e)).toList();
    });
  }

  Future<void> _deleteTOpic(int id) async {
    final db = await AppDatabase.initDB();
    await db.delete('topic', where: 'id = ?', whereArgs: [id]);
    _loadTopics();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Eliminado correctamente")));
  }

  void _ShowEdit(Topic topic) {
    final titlectrl = TextEditingController(text: topic.title);
    final conentctrl = TextEditingController(text: topic.content);
    final datectrl = TextEditingController(text: topic.date);
    final entrada = datectrl.text.trim();

    bool iscompleted = topic.state;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Editar Tema"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Text('El id de la leccion es ${topic.id}'),
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
                  final entrada = datectrl.text.trim();

                  if (entrada.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("La fecha está vacía")),
                    );
                    return;
                  }

                  late String fechaiso;

                  if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(entrada)) {
                    fechaiso = entrada;
                  } else {
                    try {
                      fechaiso = DateFormat(
                        'yyyy-MM-dd',
                      ).format(DateFormat('dd/MM/yyyy').parse(entrada));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Formato inválido. Usa DD/MM/YYYY"),
                        ),
                      );
                      return;
                    }
                  }

                  final db = await AppDatabase.initDB();
                  await db.update(
                    'topic',
                    {
                      'title': titlectrl.text,
                      'content': conentctrl.text,
                      'date': fechaiso,
                    },
                    where: 'id = ?',
                    whereArgs: [topic.id],
                  );
                  Navigator.pop(context);
                  _loadTopics();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Editado correctamente")),
                  );
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
      appBar: AppBar(
        title: const Text('Lista de Temas', style: AppTextStyles.titlesW),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: datecontroller,
                    decoration: InputDecoration(label: Text("Buscar leccion")),
                  ),
                ),
                const SizedBox(width: 20),
                FilledButton.icon(
                  onPressed: () {
                    final entrada =
                        datecontroller.text
                            .trim(); // Tomamos lo que escribió el usuario
                    try {
                      // Si el campo está vacío, mostramos un mensaje
                      if (entrada.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Esta vacio")),
                        );
                      } else {
                        // Convertimos la fecha escrita (por ejemplo "29/07/2006") al formato ISO ("2006-07-29")
                        // Esto es importante porque la base de datos guarda las fechas en ese formato
                        final fechaIso = DateFormat(
                          'yyyy-MM-dd',
                        ).format(DateFormat('dd/MM/yyyy').parse(entrada));

                        // función que busca temas por esa fecha
                        _searchbydate(fechaIso);
                      }
                    } catch (e) {
                      //usuario escribió mal la fecha, mostramos un mensaje de error
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Formato inválido. Usa DD/MM/YYYY"),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.search),
                  label: const Text("Buscar"),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: topics.length,
                itemBuilder: (_, index) {
                  final topic = topics[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Parte izquierda: título y estado
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(topic.title),
                                const SizedBox(height: 4),
                                Text(
                                  'Estado: ${topic.state ? "Completado" : "Pendiente"}',
                                ),
                              ],
                            ),
                          ),

                          // Parte derecha: botones
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteTOpic(topic.id!),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _ShowEdit(topic),
                              ),
                            ],
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
              style: ButtonStyles.elevatedbutton3,
              child: const Text('Volver', style: AppTextStyles.button3),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
