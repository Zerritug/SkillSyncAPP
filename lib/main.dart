import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillsync/features/Providers/PhraseProvider.dart';
import 'package:skillsync/features/Providers/ReminderProvider.dart';
import 'routing/AppRouter.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PhraseProvider()..loadPhrases()),
        ChangeNotifierProvider(
          create: (_) => ReminderProvider()..loadReminders(),
        ),
        // Puedes seguir agregando más providers aquí
      ],
      child: const SkillSyncApp(),
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
