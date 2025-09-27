class User {
  final int? id;
  final String name;
  final String level;

  User({this.id, required this.name, required this.level});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'level': level};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(id: map['id'], name: map['name'], level: map['level']);
  }
}
