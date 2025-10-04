import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  /// plguin
  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _plugin.initialize(settings);

    // Crear canal de notificaciones para Android
    const channel = AndroidNotificationChannel(
      'reminder_channel',
      'Reminders',
      description: 'Scheduled reminders',
      importance: Importance.high,
    );

    final androidPlugin =
        _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await androidPlugin?.createNotificationChannel(channel);
  }

  /// not y fecha exacta
  static Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    final scheduled = tz.TZDateTime.from(dateTime, tz.local);
    print('🧭 Programando notificación para: $scheduled');

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          channelDescription: 'Scheduled reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: null,
    );
  }

  static Future<void> cancelReminder(int id) async {
    await _plugin.cancel(id);
  }

  static Future<void> cancelAllReminders() async {
    await _plugin.cancelAll();
  }

  static Future<void> solicitarPermisoNotificacion() async {
    final status = await Permission.notification.request();

    if (status.isGranted) {
      print('Permiso de notificación concedido');
    } else if (status.isDenied) {
      print('Permiso de notificación denegado');
    } else if (status.isPermanentlyDenied) {
      print('Permiso de notificación bloqueado permanentemente');
    }
  }

  static Future<void> solicitarPermisoExactAlarms() async {
    final status = await Permission.scheduleExactAlarm.request();

    if (status.isGranted) {
      print('Permiso de alarmas exactas concedido');
    } else {
      print('Permiso de alarmas exactas denegado');
    }
  }
}
