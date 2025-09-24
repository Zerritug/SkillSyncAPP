import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../db/SKDataBase.dart';

class MindMap extends StatefulWidget {
  const MindMap({super.key});

  @override
  State<MindMap> createState() => _MindMapState();
}

class _MindMapState extends State<MindMap> {
  String statusMessage = 'Cargando...';

  @override
  void initState() {
    super.initState();
    _initDB();
  }

  Future<void> _initDB() async {
    try {
      final db = await AppDatabase.initDB();
      await db.insert('user', {'name': 'Alice', 'level': 'beginner'});
      final users = await db.query('user');
      setState(() {
        statusMessage = 'Usuarios cargados: ${users.length}';
      });
      print(users);
    } catch (e) {
      setState(() {
        statusMessage = 'Error al cargar usuarios';
      });
      print('DB error: $e');
    }
  }

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
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}
