import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillsync/core/theme/app_colors.dart';
import 'package:skillsync/core/theme/app_layouts.dart';
import 'package:skillsync/core/theme/text_styles.dart';
import 'package:skillsync/features/Providers/ReminderProvider.dart';
import 'package:skillsync/db/Models/Reminder.dart';
import 'package:go_router/go_router.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reminderProvider = context.watch<ReminderProvider>();
    final reminders = reminderProvider.reminders;

    return Scaffold(
      appBar: AppBar(title: const Text('Recordatorios')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                final messageController = TextEditingController();
                final timeController = TextEditingController();
                final dateController = TextEditingController();

                await showDialog(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        title: const Text("Nuevo recordatorio"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: messageController,
                              decoration: const InputDecoration(
                                labelText: "Mensaje",
                              ),
                            ),
                            TextField(
                              controller: dateController,
                              decoration: const InputDecoration(
                                labelText: "Fecha",
                              ),
                            ),
                            TextField(
                              controller: timeController,
                              decoration: const InputDecoration(
                                labelText: "Hora",
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              if (messageController.text.isNotEmpty) {
                                final reminder = Reminder(
                                  message: messageController.text,
                                  date: dateController.text,
                                  time: timeController.text,
                                  isenabled: true,
                                );
                                reminderProvider.addReminder(reminder);
                                Navigator.pop(context);
                              }
                            },
                            child: const Text("Guardar"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancelar"),
                          ),
                        ],
                      ),
                );
              },
              style: ButtonStyles.elevatedbutton1,
              child: Text("Agregar", style: AppTextStyles.button3),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.tertiary,
                border: Border.all(width: 0.5, color: AppColors.sixtiary),
                borderRadius: BorderRadius.circular(12),
              ),
              width: 350,
              height: 500,
              child: ListView.builder(
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
                            value: reminder.isenabled,
                            onChanged:
                                (val) => reminderProvider.toggleReminder(
                                  reminder.id!,
                                  val,
                                ),
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
          ],
        ),
      ),
    );
  }
}
