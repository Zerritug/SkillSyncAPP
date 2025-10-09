import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillsync/features/Providers/PhraseProvider.dart';
import 'package:skillsync/features/Providers/ReminderProvider.dart';
import 'routing/AppRouter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'package:skillsync/services/NotificationService.dart';

import 'package:skillsync/welcomescreen/screens/welcomescreen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin(); //llama a la libreria para poder ser usada con el plugin

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones(); //inicializa la libreria de timezones

  const androidSettings = AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  ); //inicializa las configuraciones necesarias para android
  const initSettings = InitializationSettings(
    android: androidSettings,
  ); // inicializa las configuracion para android

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
  ); //inicializa las notificaciones del plugin segun initsetings

  await NotificationService.init(); //espera ser inizializado el servicio de notificaciones
  await NotificationService.solicitarPermisoNotificacion(); //espera ser inizializadp el permiso de notificaciones aqui lo llama y delcara si fue o no aceptado
  await NotificationService.solicitarPermisoExactAlarms(); //espera ser inizializadp  eñ permiso de alarmasaqui se llama y delcara si fue aceptado o no

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PhraseProvider(),
        ), //crea los providers o los inicializa // ṕhrase provider
        ChangeNotifierProvider(
          create: (_) => ReminderProvider(),
        ), //crea los providers o los inicializa // reminders provider
      ],
      child: const SkillSyncApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'SkillSync', home: const WelcomeScreen());
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
