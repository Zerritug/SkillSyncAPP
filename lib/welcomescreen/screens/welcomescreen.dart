import 'package:flutter/material.dart';

import 'package:skillsync/mainmenu/screens/mainmenu.dart';
import 'package:go_router/go_router.dart';



class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('SkillSync', style: TextStyle(fontSize: 50)),
            const SizedBox(height: 50),
            const Text('Cada dia es una nueva oportunidad para aprender algo nuevo',),
            const SizedBox(height: 100),
             Container(
              height: 50,
              width: 200,
              aligment: Alignment.center,
           child: TextField(
            decoration: InputDecoration(
              labelText: 'Ingresa tu nombre',
            border: OutlineInputBorder(),
                ),
              ),
            ),   

            const SizedBox(height: 20, width: 20),

            ElevatedButton(
              onPressed: () {
               context.go('/mainmenu');
               

              },
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
