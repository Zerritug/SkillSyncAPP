import 'package:flutter/material.dart';
import 'package:skillsync/db/Models/Phrase.dart';
import 'package:skillsync/db/SKDataBase.dart';

class PhraseProvider extends ChangeNotifier {
  List<Phrase> _phrases = [];
  List<Phrase> get phrases => _phrases;

  Future<void> loadPhrases() async {
    final db = await AppDatabase.initDB();
    final result = await db.query('phrase');
    _phrases = result.map((e) => Phrase.fromMap(e)).toList();
    notifyListeners(); // avisar a las pantallas
  }

  //aladir frase
  Future<void> addPhrase(String text) async {
    final db = await AppDatabase.initDB();
    await db.insert('phrase', {'text': text});
    await loadPhrases();
  }

  Future<void> deletePhrase(int id) async {
    final db = await AppDatabase.initDB();
    await db.delete('phrase', where: 'id = ?', whereArgs: [id]);
    await loadPhrases();
  }
}
