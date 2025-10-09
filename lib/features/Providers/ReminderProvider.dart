import 'package:flutter/material.dart';
import 'package:skillsync/db/Models/Reminder.dart';
import 'package:skillsync/db/SKDataBase.dart';
import 'package:skillsync/services/NotificationService.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

//aqui estamos usando el provider para poder hacer las notificaciones y no tener toda la logica en una sola pantalla
// con esto logramos un mejor control

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
      //fecha actual
      final rawDate = reminder.date.trim().replaceAll('/', '-');

      // hora actual
      String cleanedTime = reminder.time.trim();

      // conversion en dado caso el usuario escriba mal la hora ejemplo "4:6 " a "04:06"
      final timeParts = cleanedTime.split(':');
      String hour = timeParts[0].padLeft(2, '0');
      String minute =
          timeParts.length > 1 ? timeParts[1].padLeft(2, '0') : '00';
      final rawTime = '$hour:$minute:00';

      // cadena completa
      final fullString = '$rawDate $rawTime';
      print('fecha completa: "$fullString"');

      // parseo de la fecha
      final dateFormat = DateFormat(
        "dd-MM-yyyy HH:mm:ss",
      ); //dateformat viene del paquete implementado intl, se usa para formatear fechas de cadenas de texto
      final dateTime = dateFormat.parseStrict(
        fullString,
      ); //cadena de texto con la fecha
      final scheduledDate = tz.TZDateTime.from(dateTime, tz.local).add(
        Duration(seconds: 10),
      ); //convertidor de la fecha a la actual y se le agrega mas de 10 segundos para evitar errores

      print('Ahora: ${tz.TZDateTime.now(tz.local)}'); //funcionamiento
      print(' Programado: $scheduledDate'); //probar funcionamiento

      if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
        print('Fecha inválida: el recordatorio está en el pasado');
        return;
      } //validar si la fecha es efectivamente correcta y no esta pasada de la hora actual por lo cual no se dispara

      if (isEnabled) {
        print('Programando notificación para $scheduledDate');
        await NotificationService.scheduleReminder(
          id: id,
          title: 'Recordatorio',
          body: reminder.message,
          dateTime: scheduledDate,
        ); //muestra si la notificacion esta activa y da informacion basica sobnre ella
      } else {
        print('Cancelando notificación para id $id');
        await NotificationService.cancelReminder(
          id,
        ); //explicacion en el service de notificacion
      }
    } catch (e) {
      print('rror al parsear fecha y hora del reminder: $e');
    }

    await loadReminders();
  }
}
