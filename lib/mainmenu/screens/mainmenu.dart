import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillsync/core/constants.dart';
import 'package:skillsync/core/theme/text_styles.dart';
import 'package:skillsync/core/theme/app_colors.dart';
import 'package:skillsync/core/theme/app_layouts.dart';
import 'package:skillsync/db/Models/Phrase.dart';

import 'package:skillsync/db/SKDataBase.dart';
import 'package:skillsync/db/Models/User.dart';
import 'package:skillsync/db/Models/Objetive.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => MainMenuScreenState();
}

class MainMenuScreenState extends State<MainMenuScreen> {
  // user
  User? user;
  //cargar usuario
  Future<void> _loaduserdata() async {
    final db = await AppDatabase.initDB();
    final result = await db.query('user');

    if (result.isNotEmpty) {
      setState(() {
        user = User.fromMap(result.first);
      });
    }
  }
//phrase 

List<Phrase> Phrases = [];

Future<void> _loadphrases() async {
  final db = await AppDatabase.initDB();
  final result = await db.query('phrase');

  if (result.isNotEmpty) {
    setState(() {
      Phrases = result.map((e) => Phrase.fromMap(e)).toList();
    });
  }
}

  //objetive

  List<weeklyobjective> Objetives = [];

  //funcion agregar objetivo
  Future<void> _addObjetive() async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController dateController = TextEditingController();
    bool isCompleted = false;

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          //se agrega Statefulbuilder por que oermite al chebox actualizar su estado sin que crashe
          builder: (context, setDialogState) {
            //setdialog state para poder cambiar el estado del chebox actua como un setstate
            return AlertDialog(
              title: const Text('Agregar Objetivo'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: "Título"),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Descripción",
                      ),
                    ),
                    TextField(
                      controller: dateController,
                      decoration: const InputDecoration(labelText: "Fecha"),
                    ),
                    Row(
                      children: [
                        const Text("Completado"),
                        Checkbox(
                          value: isCompleted,
                          onChanged: (val) {
                            setDialogState(() {
                              isCompleted = val ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (titleController.text.isEmpty ||
                        descriptionController.text.isEmpty ||
                        dateController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Faltan Datos")),
                      );
                      return;
                    }

                    final db = await AppDatabase.initDB();
                    await db.insert('weekly_objective', {
                      'title': titleController.text,
                      'description': descriptionController.text,
                      'date': dateController.text,
                      'state': isCompleted ? 1 : 0,
                    });

                    titleController.clear();
                    descriptionController.clear();
                    dateController.clear();

                    if (context.mounted) {
                      Navigator.of(context).pop(); // Cierra el diálogo
                      _loadobjetives();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Objetivo agregado correctamente"),
                        ),
                      );
                    }
                  },
                  child: const Text("Guardar"),
                ),
                TextButton(
                  onPressed:
                      () =>
                          Navigator.of(
                            context,
                          ).pop(), //cierra automaticamente luego de guardarla
                  child: const Text("Cancelar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _loadobjetives() async {
    final db = await AppDatabase.initDB();
    final result = await db.query('weekly_objective');
    if (result.isNotEmpty) {
      setState(() {
        Objetives = result.map((e) => weeklyobjective.fromMap(e)).toList();
      });
    }
  }

  Future<void> _deleteobjetive(int id) async {
    final db = await AppDatabase.initDB();
    await db.delete('weekly_objective', where: 'id = ?', whereArgs: [id]);
    _loadobjetives();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Objetivo eliminado correctamente")),
    );
  }

  @override
  void initState() {
    super.initState();
    //cargar usuario y objetivo
    _loaduserdata();
    _loadobjetives();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors:
                  AppColors
                      .appbargradient, //usa lista de colores en app colors.
            ),
          ),
        ),
        title: Padding(
          padding: LayoutStyles.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user != null
                    ? 'Bienvenido, ${user!.name}'
                    : 'Cargando usuario...',
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
              //estilo de texto
              Text(
                'Nivel de usuario: $level',
                style: AppTextStyles.userlevel,
              ), //estilo de texto
            ],
          ),
        ),
      ),

      backgroundColor: AppColors.tertiary,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Botones superiores
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.go('/stats');
                    },
                    style: ButtonStyles.elevatedbutton1,
                    child: const Text(
                      'Estadísticas',
                      style: AppTextStyles.button1,
                    ),
                  ),
                  const SizedBox(width: 40),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/mindmap');
                    },
                    style: ButtonStyles.elevatedbutton1,
                    child: const Text('MindMap', style: AppTextStyles.button1),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Contenedor Work In Progress
              Container(
                decoration: BoxDecoration(
                  color: AppColors.tertiary,
                  border: Border.all(width: 0.5, color: AppColors.sixtiary),
                  borderRadius: BorderRadius.circular(12),
                ),
                width: 350,
                height: 200,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Work In Progress",
                        style: AppTextStyles.greeting2,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Text("Acciones Rápidas", style: AppTextStyles.titles),
              const SizedBox(height: 40),

              // Botones de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.go('/addLessons');
                    },
                    style: ButtonStyles.elevatedbutton1,
                    child: const Text(
                      'Añadir Lecciones',
                      style: AppTextStyles.button1,
                    ),
                  ),
                  const SizedBox(width: 40),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/addTopics');
                    },
                    style: ButtonStyles.elevatedbutton1,
                    child: const Text(
                      'Añadir Tema',
                      style: AppTextStyles.button1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => context.go('/viewLessons'),
                    style: ButtonStyles.elevatedbutton2,
                    child: const Text(
                      'Ver Lecciones',
                      style: AppTextStyles.button2,
                    ),
                  ),
                  const SizedBox(width: 40),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/viewTopics');
                    },
                    style: ButtonStyles.elevatedbutton2,
                    child: const Text(
                      'Ver Temas',
                      style: AppTextStyles.button2,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Objetivos Diarios
              const Text("Objetivos Semanales", style: AppTextStyles.titles),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  ElevatedButton(
                    onPressed: _addObjetive,
                    style: ButtonStyles.elevatedbutton1,
                    child: Text("Agregar", style: AppTextStyles.button3),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.tertiary,
                  border: Border.all(width: 0.5, color: AppColors.sixtiary),
                  borderRadius: BorderRadius.circular(12),
                ),
                width: 300,
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ListView.builder(
                    itemCount: Objetives.length,
                    itemBuilder: (_, index) {
                      final objetive = Objetives[index];
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            objetive.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          objetive.date,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(objetive.description),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Estado: ${objetive.state ? "Completado" : "Pendiente"}',
                                          style: TextStyle(
                                            color:
                                                objetive.state
                                                    ? Colors.green
                                                    : Colors.orange,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed:
                                              () =>
                                                  _deleteobjetive(objetive.id!),
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
