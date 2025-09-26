import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../db/SKDataBase.dart';
import 'package:skillsync/core/theme/app_layouts.dart';
import 'package:skillsync/core/theme/text_styles.dart';
class Estadisticas extends StatefulWidget {
  const Estadisticas({super.key});

  @override
  State<Estadisticas> createState() => _EstadisticasState();
}

class _EstadisticasState extends State<Estadisticas> {
  String statusMessage = 'Cargando...';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estadísticas')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Estadísticas'),
            const SizedBox(height: 10),
            Text("work in progress"),
            const SizedBox(height: 20),
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
