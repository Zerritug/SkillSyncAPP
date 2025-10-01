import 'package:flutter/material.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'routing/AppRouter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 

  runApp(const SkillSyncApp());
}

class SkillSyncApp extends StatelessWidget {
  const SkillSyncApp({super.key});
  @override
  Widget build(BuildContext context) {
    // <-- corregido aquí
    return MaterialApp.router(
      title: 'SkillSync',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: appRouter,
    );
  }
}
