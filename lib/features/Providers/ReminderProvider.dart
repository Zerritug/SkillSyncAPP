import 'package:flutter/material.dart';
import 'package:skillsync/db/Models/Reminder.dart';
import 'package:skillsync/db/SKDataBase.dart';

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
    await loadReminders();
  }
}
