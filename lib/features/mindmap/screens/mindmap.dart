import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MindMap extends StatefulWidget {
  const MindMap({super.key});

  @override
  State<MindMap> createState() => _MindMapState();
}

class _MindMapState extends State<MindMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mind Map')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('MindMap'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go('/mainmenu');
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
