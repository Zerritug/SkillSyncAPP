import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../db/SKDataBase.dart';
import 'package:skillsync/core/theme/app_layouts.dart';
import 'package:skillsync/core/theme/text_styles.dart';

class MindMap extends StatefulWidget {
  const MindMap({super.key});

  @override
  State<MindMap> createState() => _MindMapState();
}

class _MindMapState extends State<MindMap> {
  String statusMessage = 'Cargando...';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mind Map')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('MindMap'),
            const SizedBox(height: 10),
            Text(statusMessage),
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
