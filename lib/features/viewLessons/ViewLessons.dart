import 'package:flutter/material.dart';
import 'package:skillsync/core/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.deleteSuccess)),
    );
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
            title: Text(AppLocalizations.of(context)!.editLessonTitle),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: titlectrl,
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.editTitleLabel,
                        ),
                      ),
                      TextField(
                        controller: conentctrl,
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.editContentLabel,
                        ),
                      ),
                      TextField(
                        controller: datectrl,
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.editDateLabel,
                        ),
                      ),
                      TextField(
                        controller: categoryidctrl,
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.editCategoryIdLabel,
                        ),
                      ),
                      Row(
                        children: [
                          Text(AppLocalizations.of(context)!.completedLabel),
                          Checkbox(
                            value: iscompleted,
                            onChanged:
                                (val) =>
                                    setState(() => iscompleted = val ?? false),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
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
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(
                              context,
                            )!.invalidDateFormatMessage,
                          ),
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
                      'state':
                          iscompleted
                              ? 1
                              : 0, // se agrego el estado para poder cambiar el tipo de estado y se pudiera mostrar, como completo o incompleto
                    },
                    where: 'id = ?',
                    whereArgs: [lesson.id],
                  );
                  Navigator.pop(context);
                  _loadLessons();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.editSuccess),
                    ),
                  );
                },
                child: Text(AppLocalizations.of(context)!.saveButton),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.cancelButton),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // alias corto
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.lessonsListTitle, style: AppTextStyles.titlesW),
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
                    decoration: InputDecoration(
                      labelText: l10n.searchLessonLabel,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                FilledButton.icon(
                  onPressed: () {
                    final entrada = _dateSearchCtrl.text.trim();

                    if (entrada.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.emptyFieldMessage)),
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
                          SnackBar(
                            content: Text(l10n.invalidDateFormatMessage),
                          ),
                        );
                      }
                    } else if (dropdownbuttonvalue == 'Titulo') {
                      try {
                        _searchbytitle(entrada);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.textNotFoundMessage)),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.search),
                  label: Text(l10n.searchButton),
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
                                  l10n.statusLabel(
                                    lesson.state
                                        ? l10n.completedStatus
                                        : l10n.pendingStatus,
                                  ),
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
              child: Text(l10n.backButton, style: AppTextStyles.button3),
            ),
          ],
        ),
      ),
    );
  }
}
