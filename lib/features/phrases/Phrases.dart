import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillsync/db/Models/Phrase.dart';
import 'package:skillsync/core/theme/app_layouts.dart';
import 'package:skillsync/core/theme/text_styles.dart';
import 'package:skillsync/db/SKDataBase.dart';

class FrasesMotivacionales extends StatefulWidget {
  const FrasesMotivacionales({super.key});

  @override
  State<FrasesMotivacionales> createState() => _FrasesMotivacionalesState();
}

class _FrasesMotivacionalesState extends State<FrasesMotivacionales> {

  
List<Phrase> Phrases = [];

Future<void> _loadphrases() async {
  final db = await AppDatabase.initDB();
  final result = await db.query('phrase');

  if (result.isNotEmpty) {
    setState(() {
      Phrases = result.map((e) => Phrase.fromMap(e)).toList();
    });
  }
}

Future <void> _addprahse() async {
  final TextEditingController phrasetext = TextEditingController();
  
  await showDialog(context: context, builder: (_){
  return AlertDialog(
    title: const Text("Agregar frase"),
    content: SingleChildScrollView(
      child: Column(
        children: [
          TextField(controller: phrasetext, decoration: const InputDecoration(labelText: "Frase"),)
        ],
      ),
    ),
    actions: [
      TextButton(onPressed: () async{
        if (phrasetext.text.isEmpty){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: const Text ("No puede estar vacio"))
          );
          return;
        }
        final db = await AppDatabase.initDB();
        await db.insert('phrase', {
          'text': phrasetext.text
        });
        phrasetext.clear();

        if (context.mounted) {
         Navigator.of(context).pop();
         _loadphrases();

         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: const Text ("Frase agregada correctamente"))); 
        };
      } , child: const Text ("Guardar")
      ),
      TextButton(
                  onPressed:
                      () =>
                          Navigator.of(
                            context,
                          ).pop(), //cierra automaticamente luego de guardarla
                  child: const Text("Cancelar"),
                ),
    ],
  );
});
  

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Frases Motivacionales')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: _addprahse, child: Text ("Agregar")),
              const Card(
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      '',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.go('/mainmenu');
                },
                style: ButtonStyles.elevatedbutton3,
                child: const Text('Volver', style: AppTextStyles.button3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
