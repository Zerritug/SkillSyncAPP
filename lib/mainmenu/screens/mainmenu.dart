import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillsync/core/constants.dart';
import 'package:skillsync/core/theme/text_styles.dart';
import 'package:skillsync/core/theme/app_colors.dart';
import 'package:skillsync/core/theme/app_layouts.dart';
import 'package:skillsync/routing/route_names.dart';
import 'package:skillsync/db/SKDataBase.dart';
import 'package:skillsync/db/Models/User.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => MainMenuScreenState();
}

class MainMenuScreenState extends State<MainMenuScreen> {
  User? user;

  Future<void> _loaduserdata() async {
    final db = await AppDatabase.initDB();
    final result = await db.query('user');

    if (result.isNotEmpty) {
      setState(() {
        user = User.fromMap(result.first);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loaduserdata();
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
              Container(
                decoration: BoxDecoration(
                  color: AppColors.tertiary,
                  border: Border.all(width: 0.5, color: AppColors.sixtiary),
                  borderRadius: BorderRadius.circular(12),
                ),
                width: 300,
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    SizedBox(height: 8),
                    SizedBox(height: 40),
                    Text("Objetivos Diarios"),
                    SizedBox(height: 30),
                    Text("WORK IN PROGRESS"),
                  ],
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
