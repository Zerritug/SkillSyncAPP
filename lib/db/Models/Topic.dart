class Topic {
  final int? id; //puede ser nulo
  final String title;
  final String content;
  final String date;
  final bool state;

  Topic({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.state,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
      'state': state,
    };
  }

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: map['date'],
      state: map['state'] == 1,
    );
  }
}
