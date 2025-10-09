import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:skillsync/core/theme/app_colors.dart';
import 'package:skillsync/core/theme/app_layouts.dart';
import 'package:skillsync/core/theme/text_styles.dart';
import 'package:skillsync/features/Providers/ReminderProvider.dart';
import 'package:skillsync/db/Models/Reminder.dart';
import 'package:go_router/go_router.dart';
import 'package:skillsync/services/NotificationService.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart'; // IMPORTANTE para DateFormat
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reminderProvider =
        context
            .watch<
              ReminderProvider
            >(); //espera el contenido funciones,controladores etc delprovider de reminders
    final reminders = reminderProvider.reminders;
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    void mostrarNotificacionSimple() async {
      await flutterLocalNotificationsPlugin.show(
        0,
        '¡Hola Runny!',
        'Esta es una notificación de prueba 🎉',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminder_channel',
            'Pruebas',
            channelDescription: 'Canal para pruebas simples',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    } // canal prueba, se hizo para verificar errores dentro del codigo y saber que tipo de problema sugeria

    return Scaffold(
      appBar: AppBar(title: const Text('Recordatorios')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {},
              style: ButtonStyles.elevatedbutton1,
              child: Text("Agregar", style: AppTextStyles.button3),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.tertiary,
                border: Border.all(width: 0.5, color: AppColors.sixtiary),
                borderRadius: BorderRadius.circular(12),
              ),
              width: 350,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reminders.length,
                itemBuilder: (_, index) {
                  final reminder = reminders[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(reminder.message),
                      subtitle: Text("${reminder.date} • ${reminder.time}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: reminder.isEnabled,
                            onChanged: (val) async {
                              await reminderProvider.toggleReminder(
                                reminder.id!,
                                val,
                              );
                              print(
                                'Notificación ${val ? "activada" : "cancelada"} para ${reminder.message}',
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed:
                                () => reminderProvider.deleteReminder(
                                  reminder.id!,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/mainmenu'),
              style: ButtonStyles.elevatedbutton3,
              child: const Text('Volver', style: AppTextStyles.button3),
            ),
            ElevatedButton(
              onPressed: () async {
                await flutterLocalNotificationsPlugin.show(
                  999,
                  'Test canal programado',
                  '¿Este canal muestra notificaciones?',
                  const NotificationDetails(
                    android: AndroidNotificationDetails(
                      'scheduled_channel',
                      'Scheduled Reminders',
                      channelDescription:
                          'Canal para notificaciones programadas',
                      importance: Importance.high,
                      priority: Priority.high,
                    ),
                  ),
                );
              },
              child: const Text('Probar canal programado'),
            ),
            ElevatedButton(
              onPressed: () async {
                await openAppSettings();
              },
              child: const Text('Abrir ajustes de notificación'),
            ),
            ElevatedButton(
              onPressed: () async {
                final pending =
                    await flutterLocalNotificationsPlugin
                        .pendingNotificationRequests();
                print('🔍 Notificaciones pendientes: ${pending.length}');
                for (var p in pending) {
                  print('📝 id: ${p.id}, title: ${p.title}, body: ${p.body}');
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Hay ${pending.length} notificaciones pendientes',
                    ),
                  ),
                );
              },
              child: const Text('Ver notificaciones pendientes'),
            ),
          ],
        ),
      ),
    );
  }
}
