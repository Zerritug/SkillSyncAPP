import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillsync/features/Providers/PhraseProvider.dart';
import 'package:skillsync/features/Providers/ReminderProvider.dart';
import 'routing/AppRouter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:skillsync/services/NotificationService.dart';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidSettings);

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  await NotificationService.init(); // ← si usas lógica adicional ahí
  await NotificationService.solicitarPermisoNotificacion();
  await NotificationService.solicitarPermisoExactAlarms();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PhraseProvider()),
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
      ],
      child: const SkillSyncApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillSync',
      home: Scaffold(body: Center(child: Text('SkillSync'))),
    );
  }
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
