import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:skillsync/core/theme/text_styles.dart';
import 'package:skillsync/core/theme/app_colors.dart';
import 'package:skillsync/core/theme/app_layouts.dart';
import 'package:skillsync/db/Models/Phrase.dart';
import 'package:skillsync/features/Providers/PhraseProvider.dart';
import 'package:skillsync/db/SKDataBase.dart';
import 'package:skillsync/db/Models/User.dart';
import 'package:skillsync/db/Models/Objetive.dart';
import 'package:skillsync/main.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => MainMenuScreenState();
}

class MainMenuScreenState extends State<MainMenuScreen> {
  User? user;
  List<weeklyobjective> Objetives = [];

  Future<void> _showSettings() async {
    final themeprovider = Provider.of<ThemeProvider>(
      context,
      listen: false,
    ); //provider declarado en main

    bool isDarkTheme =
        themeprovider.isDarkMode; //validar si tiene activado el modo oscuro

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              backgroundColor:
                  themeprovider.isDarkMode
                      ? AppColors.darkSurface
                      : Colors.white,
              title: Text(
                "Settings",
                style: TextStyle(
                  color:
                      themeprovider.isDarkMode
                          ? AppColors.darkText
                          : Colors.black,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    CheckboxListTile(
                      title: Text(
                        "Tema oscuro",
                        style: TextStyle(
                          color:
                              themeprovider.isDarkMode
                                  ? AppColors.darkText
                                  : Colors.black,
                        ),
                      ),
                      activeColor: AppColors.primary,
                      value: isDarkTheme,
                      onChanged: (val) {
                        setDialogState(() {
                          isDarkTheme = val ?? false;
                        });
                        themeprovider.toggleTheme(isDarkTheme);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cerrar",
                    style: TextStyle(
                      color:
                          themeprovider.isDarkMode
                              ? AppColors.darkText
                              : Colors.black,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _loaduserdata() async {
    final db = await AppDatabase.initDB();
    final result = await db.query('user');
    if (result.isNotEmpty) {
      setState(() {
        user = User.fromMap(result.first);
      });
    }
  }

  Future<void> _addObjetive() async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController dateController = TextEditingController();
    bool isCompleted = false;

    await showDialog(
      context: context,
      builder: (_) {
        final themeprovider = Provider.of<ThemeProvider>(
          context,
          listen: false,
        );
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor:
                  themeprovider.isDarkMode
                      ? AppColors.darkSurface
                      : Colors.white,
              title: Text(
                'Agregar Objetivo',
                style: TextStyle(
                  color:
                      themeprovider.isDarkMode
                          ? AppColors.darkText
                          : Colors.black,
                ),
              ),
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
                        Text(
                          "Completado",
                          style: TextStyle(
                            color:
                                themeprovider.isDarkMode
                                    ? AppColors.darkText
                                    : Colors.black,
                          ),
                        ),
                        Checkbox(
                          value: isCompleted,
                          activeColor: AppColors.primary,
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
                      Navigator.of(context).pop();
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
                  onPressed: () => Navigator.of(context).pop(),
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
    _loaduserdata();
    _loadobjetives();
  }

  @override
  Widget build(BuildContext context) {
    final themeprovider = Provider.of<ThemeProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = themeprovider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: AppColors.appbargradient,
            ),
          ),
        ),
        title: Padding(
          padding: LayoutStyles.cardPadding,
          child: Text(
            user != null ? 'Bienvenido, ${user!.name}' : 'Cargando usuario...',
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showSettings,
            icon: const Icon(Icons.settings),
          ), //mostrar boton superior de configuracion
        ],
      ),
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.tertiary,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Botones principales
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton(
                    onPressed: () => context.go('/phrases'),
                    style:
                        isDark
                            ? ButtonStyles.elevatedbuttonDark
                            : ButtonStyles.elevatedbutton1,
                    child: const Text('Frases', style: AppTextStyles.button1),
                  ),
                  ElevatedButton(
                    onPressed: () => context.go('/reminders'),
                    style:
                        isDark
                            ? ButtonStyles.elevatedbuttonDark
                            : ButtonStyles.elevatedbutton1,
                    child: const Text(
                      'Reminders',
                      style: AppTextStyles.button1,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => context.go('/mindmap'),
                    style:
                        isDark
                            ? ButtonStyles.elevatedbuttonDark
                            : ButtonStyles.elevatedbutton1,
                    child: const Text('MindMaps', style: AppTextStyles.button1),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Frases
              Consumer<PhraseProvider>(
                builder: (context, phraseProvider, _) {
                  return Container(
                    decoration: BoxDecoration(
                      color:
                          isDark ? AppColors.darkSurface : AppColors.tertiary,
                      border: Border.all(
                        width: 0.5,
                        color: isDark ? AppColors.darkHint : AppColors.sixtiary,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    width: screenWidth * 0.9,
                    height: 200,
                    child: ListView.builder(
                      itemCount: phraseProvider.phrases.length,
                      itemBuilder: (_, index) {
                        final phrase = phraseProvider.phrases[index];
                        return Card(
                          color: isDark ? AppColors.darkSurface : Colors.white,
                          margin: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 8,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              phrase.text,
                              style: TextStyle(
                                color:
                                    isDark ? AppColors.darkText : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
              Text(
                "Acciones Rápidas",
                style: isDark ? AppTextStyles.titlesW : AppTextStyles.titles,
              ),
              const SizedBox(height: 20),

              // Botones secundarios
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton(
                    onPressed: () => context.go('/addLessons'),
                    style:
                        isDark
                            ? ButtonStyles.elevatedbuttonDark
                            : ButtonStyles.elevatedbutton1,
                    child: const Text(
                      'Añadir Lecciones',
                      style: AppTextStyles.button1,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => context.go('/addTopics'),
                    style:
                        isDark
                            ? ButtonStyles.elevatedbuttonDark
                            : ButtonStyles.elevatedbutton1,
                    child: const Text(
                      'Añadir Tema',
                      style: AppTextStyles.button1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Ver temas/lecciones
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton(
                    onPressed: () => context.go('/viewLessons'),
                    style: ButtonStyles.elevatedbutton2,
                    child: const Text(
                      'Ver Lecciones',
                      style: AppTextStyles.button2,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => context.go('/viewTopics'),
                    style: ButtonStyles.elevatedbutton2,
                    child: const Text(
                      'Ver Temas',
                      style: AppTextStyles.button2,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              Text(
                "Objetivos Semanales",
                style: isDark ? AppTextStyles.titlesW : AppTextStyles.titles,
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _addObjetive,
                style:
                    isDark
                        ? ButtonStyles.elevatedbuttonDark
                        : ButtonStyles.elevatedbutton1,
                child: const Text("Agregar", style: AppTextStyles.button3),
              ),

              const SizedBox(height: 20),

              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.tertiary,
                  border: Border.all(
                    width: 0.5,
                    color: isDark ? AppColors.darkHint : AppColors.sixtiary,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                width: screenWidth * 0.9,
                height: 300,
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: Objetives.length,
                  itemBuilder: (_, index) {
                    final objetive = Objetives[index];
                    return Card(
                      color: isDark ? AppColors.darkSurface : Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    objetive.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          isDark
                                              ? AppColors.darkText
                                              : Colors.black,
                                    ),
                                  ),
                                ),
                                Text(
                                  objetive.date,
                                  style: TextStyle(
                                    color:
                                        isDark
                                            ? AppColors.darkHint
                                            : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              objetive.description,
                              style: TextStyle(
                                color:
                                    isDark ? AppColors.darkText : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      () => _deleteobjetive(objetive.id!),
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
                    );
                  },
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
