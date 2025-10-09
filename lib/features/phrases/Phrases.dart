import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillsync/core/theme/app_layouts.dart';
import 'package:skillsync/core/theme/text_styles.dart';
import 'package:skillsync/core/theme/app_colors.dart';
import 'package:skillsync/db/Models/Phrase.dart';
import 'package:skillsync/features/Providers/PhraseProvider.dart';
import 'package:go_router/go_router.dart';

class FrasesMotivacionales extends StatelessWidget {
  const FrasesMotivacionales({super.key});

  @override
  Widget build(BuildContext context) {
    final phraseProvider = context.watch<PhraseProvider>();
    final phrases =
        phraseProvider
            .phrases; //provider, este sirve como nueva variable para delcarar las listas que se consumen desde el provider
    return Scaffold(
      appBar: AppBar(title: const Text('Frases Motivacionales')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                final controller = TextEditingController();
                await showDialog(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        title: const Text("Agregar frase"),
                        content: TextField(controller: controller),
                        actions: [
                          TextButton(
                            onPressed: () {
                              if (controller.text.isNotEmpty) {
                                phraseProvider.addPhrase(controller.text);
                                Navigator.pop(context);
                              }
                            },
                            child: const Text("Guardar"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancelar"),
                          ),
                        ],
                      ),
                );
              },
              style: ButtonStyles.elevatedbutton1,
              child: Text("Agregar", style: AppTextStyles.button3),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.tertiary,
                border: Border.all(width: 0.5, color: AppColors.sixtiary),
                borderRadius: BorderRadius.circular(12),
              ),
              width: 350,
              height: 500,
              child: ListView.builder(
                itemCount: phraseProvider.phrases.length,
                itemBuilder: (_, index) {
                  final phrase = phraseProvider.phrases[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(phrase.text),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed:
                            () => phraseProvider.deletePhrase(phrase.id!),
                      ),
                    ),
                  );
                },
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
    );
  }
}
