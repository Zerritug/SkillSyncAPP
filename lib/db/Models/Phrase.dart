class Phrase {
  final int? id; 
  final String text;



  Phrase({
    this.id,
    required this.text,

  });

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'text': text,
      
    };
  }

  factory Phrase.fromMap(Map<String, dynamic> map) {
    return Phrase (
      id: map['id'],
      text: map['text'],
     
    );
  }
}
