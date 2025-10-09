class Lesson {
  final int? id; // el ? es para indicar que puede ser nulo
  final String title;
  final String content;
  final String date;
  final bool state;
  final int? userId;
  final int? categoryId;
  Lesson({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.state,
    required this.userId,
    required this.categoryId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
      'state': state ? 1 : 0, //puede ser verdadero o falso
      'user_id': userId,
      'category_id': categoryId,
    };
  }

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: map['date'],
      state: map['state'] == 1,
      userId: map['user_id'],
      categoryId: map['category_id'],
    );
  }
}
