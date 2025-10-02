import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillsync/features/Providers/PhraseProvider.dart';
import 'routing/AppRouter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create:
          (_) => PhraseProvider()..loadPhrases(), // cascade operator correcto
      child: const SkillSyncApp(), // el child es tu app
    ),
  );
}

class SkillSyncApp extends StatelessWidget {
  const SkillSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SkillSync',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: appRouter,
    );
  }
}
