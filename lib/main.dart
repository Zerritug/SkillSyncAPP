import 'package:flutter/material.dart';

import 'routing/AppRouter.dart';

void main() {
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
