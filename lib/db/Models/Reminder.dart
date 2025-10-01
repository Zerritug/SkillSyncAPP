class Reminder {
  final int? id; 
  final String message;
  final String date;
  final String time;
  final bool isenabled;


  Reminder({
    this.id,
    required this.message,
    required this.date,
    required this.time,
    required this.isenabled,
  });

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'message': message,
      'date': date,
      'time': time,
      'isenabled': isenabled,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder (
      id: map['id'],
      message: map['message'],
      date: map['date'],
      time: map['time'],
      isenabled: map['isenabled'],
    );
  }
}
