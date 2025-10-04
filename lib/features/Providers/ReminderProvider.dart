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

  Future<void> addReminder(Reminder reminder) async {
    final db = await AppDatabase.initDB();
    await db.insert('reminder', reminder.toMap());
    await loadReminders();
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

    // Usa el mismo formato exacto con el que guardas la fecha
    final dateFormat = DateFormat(
      "dd-MM-yyyy HH:mm:ss",
    ); // O dd/MM/yyyy si así guardas

    // Normaliza fecha y hora
    final rawDate = reminder.date.replaceAll('/', '-');
    final rawTime =
        reminder.time.length == 5 ? '${reminder.time}:00' : reminder.time;

    final fullString = '$rawDate $rawTime';
    print('🧭 Parseando fecha completa: $fullString');

    final dateTime = dateFormat.parse(fullString);
    final scheduledDate = tz.TZDateTime.from(dateTime, tz.local);

    print('🕒 Ahora: ${tz.TZDateTime.now(tz.local)}');
    print('🗓 Programado: $scheduledDate');

    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      print('⚠️ Fecha inválida: el recordatorio está en el pasado');
      return;
    }

    if (isEnabled) {
      await NotificationService.scheduleReminder(
        id: id,
        title: 'Recordatorio',
        body: reminder.message,
        dateTime: scheduledDate,
      );
      print('✅ Notificación programada para $scheduledDate');
    } else {
      await NotificationService.cancelReminder(id);
      print('❌ Notificación cancelada para id $id');
    }

    await loadReminders();
  }
}
