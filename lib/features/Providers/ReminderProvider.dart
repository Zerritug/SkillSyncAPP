import 'package:flutter/material.dart';
import 'package:skillsync/db/Models/Reminder.dart';
import 'package:skillsync/db/SKDataBase.dart';
import 'package:skillsync/services/NotificationService.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class ReminderProvider extends ChangeNotifier {
  List<Reminder> _reminders = [];
  List<Reminder> get reminders => _reminders;

  Future<void> loadReminders() async {
    final db = await AppDatabase.initDB();
    final result = await db.query('reminder');
    _reminders = result.map((e) => Reminder.fromMap(e)).toList();
    notifyListeners();
  }

  Future<int?> addReminder(Reminder reminder) async {
    final db = await AppDatabase.initDB();
    final id = await db.insert('reminder', reminder.toMap());
    await loadReminders();
    return id;
  }

  Future<void> deleteReminder(int id) async {
    final db = await AppDatabase.initDB();
    await db.delete('reminder', where: 'id = ?', whereArgs: [id]);
    await loadReminders();
  }

  Future<void> toggleReminder(int id, bool isEnabled) async {
    final db = await AppDatabase.initDB();
    await db.update(
      'reminder',
      {'isEnabled': isEnabled ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );

    final reminder = _reminders.firstWhere((r) => r.id == id);

    try {
      // 🧭 Normalizamos la fecha
      final rawDate = reminder.date.trim().replaceAll('/', '-');

      // 🧭 Normalizamos la hora
      String cleanedTime = reminder.time.trim();

      // El usuario podría escribir “4:6” → lo convertimos a “04:06:00”
      final timeParts = cleanedTime.split(':');
      String hour = timeParts[0].padLeft(2, '0');
      String minute =
          timeParts.length > 1 ? timeParts[1].padLeft(2, '0') : '00';
      final rawTime = '$hour:$minute:00';

      // 🧭 Construimos la cadena completa
      final fullString = '$rawDate $rawTime';
      print('🧭 Parseando fecha completa: "$fullString"');

      // 📌 Intentamos parsear
      final dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
      final dateTime = dateFormat.parseStrict(fullString);
      final scheduledDate = tz.TZDateTime.from(
        dateTime,
        tz.local,
      ).add(Duration(seconds: 10));

      print('🕒 Ahora: ${tz.TZDateTime.now(tz.local)}');
      print('🗓 Programado: $scheduledDate');

      if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
        print('⚠️ Fecha inválida: el recordatorio está en el pasado');
        return;
      }

      if (isEnabled) {
        print('✅ Programando notificación para $scheduledDate');
        await NotificationService.scheduleReminder(
          id: id,
          title: 'Recordatorio',
          body: reminder.message,
          dateTime: scheduledDate,
        );
      } else {
        print('❌ Cancelando notificación para id $id');
        await NotificationService.cancelReminder(id);
      }
    } catch (e) {
      print('❌ Error al parsear fecha y hora del reminder: $e');
    }

    await loadReminders();
  }
}
