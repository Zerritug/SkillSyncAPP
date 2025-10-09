import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:skillsync/core/theme/app_colors.dart';
import 'package:skillsync/core/theme/app_layouts.dart';
import 'package:skillsync/db/SKDataBase.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _usernameadd() async {
    final nombre = _controller.text.trim();

    if (nombre.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No puede estar vacío!")));
      return;
    }

    if (RegExp(r'[^\w\s]').hasMatch(nombre)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("El nombre no puede tener símbolos.")),
      );
      return;
    }

    final db = await AppDatabase.initDB();
    await db.insert('user', {'name': nombre});

    context.go('/mainmenu');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // el teclado al salir no tapa el contenido
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.WelcomeScreen,
          ),
        ),
        child: SafeArea(
          // barra superior, no se tapa
          child: SingleChildScrollView(
            // permite scroll
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/SkillSyncLogoW.png',
                        width: 150,
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                      const Text(
                        'SkillSync',
                        style: TextStyle(fontSize: 50, color: Colors.white),
                      ),
                      const SizedBox(height: 50),
                      const Text(
                        'Cada día es una nueva oportunidad para aprender algo nuevo',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 100),
                      Container(
                        height: 50,
                        width: 200,
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            labelText: 'Ingresa tu nombre',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _usernameadd,
                        style: ButtonStyles.elevatedbutton1,
                        child: const Text(
                          'Continuar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
