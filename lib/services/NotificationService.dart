import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final _plugin =
      FlutterLocalNotificationsPlugin(); //implementacion del plugin que da la libreria

  /// plguin
  static Future<void> init() async {
    const android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    ); //inicializa las configuraciones de android
    const settings = InitializationSettings(
      android: android,
    ); //declara las configuraciones y especifica que es de android

    await _plugin.initialize(
      settings,
    ); //espera que se inicie con el parametro de settings

    //  canal de notificaciones para Android
    const channel = AndroidNotificationChannel(
      'reminder_channel', //id del canal
      'Reminders', //nombre del canal
      description: 'Scheduled reminders', //descripcion
      importance: Importance.high, //declara la importancia
    );
    const AndroidNotificationChannel scheduledChannel =
        AndroidNotificationChannel(
          'scheduled_channel', //otro canal declara lo mismo que arriba
          'Scheduled Reminders',
          description: 'Canal para notificaciones programadas',
          importance: Importance.high,
        );

    final androidPlugin =
        _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >(); //permite obtener los metodos como createnotificationchanel que esta en la configuracion de la libreria

    await androidPlugin?.createNotificationChannel(channel);
    await androidPlugin?.createNotificationChannel(
      scheduledChannel,
    ); // crea canales definidos, se pueden verificar en la configuracion
  }

  //programa las notificaciones , con fehca y hora
  static Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    final scheduled = tz.TZDateTime.from(
      dateTime,
      tz.local,
    ); //conersion de hora normal a horario local
    print(' Programando notificación para: $scheduled');

    //programa la notifacion con el plugin
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'scheduled_channel', //id del canal que se usara
          'Scheduled Reminders', // nombre del canal
          channelDescription:
              'Canal para notificaciones programadas', //descripcion
          importance: Importance.high, //importancia y prioridad
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle:
          true, //esto permite que se puedan mostrar aun si esta en ahorro de bateria
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: null,
    );
  }

  static Future<void> cancelReminder(int id) async {
    await _plugin.cancel(
      id,
    ); //funcion para cancelar recordatorios, que usa parte del plugin
  }

  static Future<void> cancelAllReminders() async {
    await _plugin
        .cancelAll(); //cancela todos los recordatorios, segun el plugin
  }

  static Future<void> solicitarPermisoNotificacion() async {
    final status =
        await Permission.notification
            .request(); //solicitud de requisitos para poder tener notifdicaicones por parte de la aplicacion

    if (status.isGranted) {
      print('Permiso de notificación concedido');
    } else if (status.isDenied) {
      print('Permiso de notificación denegado');
    } else if (status.isPermanentlyDenied) {
      print('Permiso de notificación bloqueado permanentemente');
    }
  } //declara si los permisos fueron delcarados en consla, simple prueba para comprobar comportamiento

  static Future<void> solicitarPermisoExactAlarms() async {
    final status = await Permission.scheduleExactAlarm.request();

    if (status.isGranted) {
      print('Permiso de alarmas exactas concedido');
    } else {
      print('Permiso de alarmas exactas denegado');
    }
  }
} //declara los permisos fueron dados o no, al igual que las notificaiones en este caso las alarmas
