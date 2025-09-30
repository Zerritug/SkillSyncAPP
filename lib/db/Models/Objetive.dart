class weeklyobjective {
  final int? id;
  final String title;
  final String description;
  final String date;
  final bool state;

  weeklyobjective({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.state,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'state': state,
    };
  }

  factory weeklyobjective.fromMap(Map<String, dynamic> map) {
    return weeklyobjective(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
      state: map['state'] == 1,
    );
  }
}
