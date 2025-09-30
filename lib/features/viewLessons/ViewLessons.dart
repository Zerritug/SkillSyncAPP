import 'package:flutter/material.dart';
import 'package:skillsync/core/theme/app_colors.dart';
import 'package:intl/intl.dart';

import '../../db/SKDataBase.dart';
import '../../db/Models/Lesson.dart';
import 'package:go_router/go_router.dart';
import 'package:skillsync/core/theme/app_layouts.dart';
import 'package:skillsync/core/theme/text_styles.dart';

class LessonListScreen extends StatefulWidget {
  const LessonListScreen({super.key});

  @override
  State<LessonListScreen> createState() => _LessonListScreenState();
}

class _LessonListScreenState extends State<LessonListScreen> {
  List<Lesson> lessons = [];

  final TextEditingController _dateSearchCtrl =
      TextEditingController(); //controlador del campo de la nueva fecha
  List<String> listoptions = <String>[
    'Fecha',
    'Titulo',
  ]; //LISTA OPCIONES DROPDWONBUTTON
  String dropdownbuttonvalue = 'Fecha'; //valor inicial del dropdown
  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  //cargar lecciones
  Future<void> _loadLessons() async {
    final db = await AppDatabase.initDB();
    final result = await db.query('lesson');
    setState(() {
      lessons = result.map((e) => Lesson.fromMap(e)).toList();
    });
  }

  Future<void> _searchbytitle(String title) async {
    final db = await AppDatabase.initDB();
    final result = await db.query(
      'lesson',
      where: 'title LIKE ?',
      whereArgs: ['%$title%'],
    );
    setState(() {
      lessons = result.map((e) => Lesson.fromMap(e)).toList();
    });
  }

  //busqueda por fecha
  Future<void> _seachlessonbydate(String date) async {
    final db = await AppDatabase.initDB();
    final result = await db.query(
      'lesson',
      where: 'date = ?',
      whereArgs: [date],
    );
    setState(() {
      lessons =
          result
              .map((e) => Lesson.fromMap(e))
              .toList(); //cambio de estado para leccion
    });
  }

  Future<void> _deleteLesson(int id) async {
    final db = await AppDatabase.initDB();
    await db.delete('lesson', where: 'id = ?', whereArgs: [id]);
    _loadLessons();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Eliminado correctamente")));
  }

  //scontroladores y mostrar dialog para editar las lecciones
  void _ShowEdit(Lesson lesson) {
    final titlectrl = TextEditingController(text: lesson.title);
    final conentctrl = TextEditingController(text: lesson.content);
    final datectrl = TextEditingController(text: lesson.date);

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
                  final entrada = datectrl.text.trim(); //entrada del uisuario
                  late final String fechaIso;

                  if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(entrada)) {
                    fechaIso = entrada;
                  } else {
                    try {
                      //fecha que se escribio a el nuevo formato que seria por ejemplo 29/07/2006 a 2007-07-29
                      fechaIso = DateFormat('yyyy-MM-dd').format(
                        DateFormat('dd/MM/yyyy').parse(entrada),
                      ); //formateo de fecha ,
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
                    'lesson',
                    {
                      'title': titlectrl.text,
                      'content': conentctrl.text,
                      'date': fechaIso,
                    },
                    where: 'id = ?',
                    whereArgs: [lesson.id],
                  );
                  Navigator.pop(context);
                  _loadLessons();
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
        title: const Text('Lista de Lecciones', style: AppTextStyles.titlesW),
        backgroundColor: AppColors.quaternary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                DropdownButton(
                  //dropdown button sirve para mostrar varias opciones desplegables para eligir
                  value: dropdownbuttonvalue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  onChanged: (String? value) {
                    setState(() {
                      dropdownbuttonvalue = value!;
                    });
                  },
                  items:
                      listoptions.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                ),
                Expanded(
                  child: TextField(
                    controller: _dateSearchCtrl,
                    decoration: InputDecoration(label: Text("Buscar leccion")),
                  ),
                ),
                const SizedBox(width: 20),
                FilledButton.icon(
                  onPressed: () {
                    final entrada = _dateSearchCtrl.text.trim();

                    if (entrada.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Esta vacio")),
                      );
                      return;
                    }

                    if (dropdownbuttonvalue == 'Fecha') {
                      //si el valor principal que se declaro en la cclase
                      try {
                        //es fecha buscara por fecha en dado caso cambie de estado a titulo y buscara por ese mismo
                        final fechaIso = DateFormat(
                          'yyyy-MM-dd',
                        ).format(DateFormat('dd/MM/yyyy').parse(entrada));
                        _seachlessonbydate(fechaIso);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Formato inválido. Usa DD/MM/YYYY"),
                          ),
                        );
                      }
                    } else if (dropdownbuttonvalue == 'Titulo') {
                      try {
                        _searchbytitle(entrada);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Texto no encontrado")),
                        );
                      }
                    }
                  },

                  icon: const Icon(Icons.search),
                  label: const Text("Buscar"),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: lessons.length,
                itemBuilder: (_, index) {
                  final lesson = lessons[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Parte izquierda de la card, titulo y estado de la leccion
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(lesson.title),
                                const SizedBox(height: 4),
                                Text(
                                  'Estado: ${lesson.state ? "Completada" : "Pendiente"}',
                                ),
                              ],
                            ),
                          ),

                          // Parte derecha  botones de edicion y eliminacion
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteLesson(lesson.id!),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _ShowEdit(lesson),
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
          ],
        ),
      ),
    );
  }
}
