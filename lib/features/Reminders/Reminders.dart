import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillsync/core/theme/app_colors.dart';
import 'package:skillsync/core/theme/app_layouts.dart';
import 'package:skillsync/core/theme/text_styles.dart';
import 'package:skillsync/features/Providers/ReminderProvider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:skillsync/core/animations/Apptransitions.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reminderProvider = context.watch<ReminderProvider>();
    final reminders = reminderProvider.reminders;
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n!.remindersTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {},
              style: ButtonStyles.elevatedbutton1,
              child: Text(l10n!.addButton, style: AppTextStyles.button3),
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
                                val
                                    ? l10n!.activatedNotificationLog(
                                      reminder.message,
                                    )
                                    : l10n!.cancelledNotificationLog(
                                      reminder.message,
                                    ),
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
              onPressed: () => context.go('/mainmenu', extra: 'forward'),
              style: ButtonStyles.elevatedbutton3,
              child: Text(l10n!.backButton, style: AppTextStyles.button3),
            ),
            ElevatedButton(
              onPressed: () async {
                await flutterLocalNotificationsPlugin.show(
                  999,
                  l10n.testScheduledChannelTitle,
                  l10n.testScheduledChannelBody,
                  NotificationDetails(
                    android: AndroidNotificationDetails(
                      'scheduled_channel',
                      l10n.scheduledChannelName,
                      channelDescription: l10n.scheduledChannelDescription,
                      importance: Importance.high,
                      priority: Priority.high,
                    ),
                  ),
                );
              },
              child: Text(l10n.testScheduledChannelButton),
            ),
            ElevatedButton(
              onPressed: () async {
                final pending =
                    await flutterLocalNotificationsPlugin
                        .pendingNotificationRequests();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.pendingNotificationsCount(pending.length),
                    ),
                  ),
                );
              },
              child: Text(l10n.viewPendingNotifications),
            ),
          ],
        ),
      ),
    );
  }
}
