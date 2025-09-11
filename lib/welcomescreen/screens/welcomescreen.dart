import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillsync/core/constants.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 83, 49, 231),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'SkillSync',
                style: TextStyle(fontSize: 50, color: Colors.white),
              ),
              const SizedBox(height: 50),
              const Text(
                'Cada dia es una nueva oportunidad para aprender algo nuevo',
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
              const SizedBox(height: 20, width: 20),
              ElevatedButton(
                onPressed: () {
                  if (_controller.text.trim().isEmpty) {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Error'),
                            content: const Text(
                              'Por favor ingresa un nombre válido.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                    );
                    return;
                  }
                  userName = _controller.text;
                  context.go('/mainmenu');
                },
                child: const Text('Continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
