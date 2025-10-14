import 'package:flutter/material.dart';
import 'package:skillsync/core/theme/app_colors.dart';

import '../../db/SKDataBase.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:skillsync/core/theme/app_layouts.dart';
import 'package:skillsync/core/theme/text_styles.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  State<LessonScreen> createState() => _LessonScreen();
}

class _LessonScreen extends State<LessonScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final TextEditingController categoryIdController = TextEditingController();

  bool state = false;

  Future<void> _addLesson() async {
    final loc = AppLocalizations.of(context)!;
    if (titleController.text.isEmpty ||
        contentController.text.isEmpty ||
        dateController.text.isEmpty ||
        categoryIdController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.missingDataMessageADD)));
      return;
    }

    final categoryId = int.tryParse(categoryIdController.text);
    if (categoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.topicNotFoundMessage)));
    }

    final db = await AppDatabase.initDB();
    final result = await db.query(
      'topic',
      where: 'id = ?',
      whereArgs: [categoryId],
    );

    if (result.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.invalidCategoryIdMessage)));
      return;
    }
    await db.insert('lesson', {
      'title': titleController.text,
      'content': contentController.text,
      'date': dateController.text,
      'state': state ? 1 : 0,

      'category_id': int.tryParse(categoryIdController.text) ?? 0,
    });
    titleController.clear(); //limpia el campo para poder agregar uno nuevo
    contentController.clear();
    dateController.clear();

    categoryIdController.clear();
    setState(() => state = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(loc.lessonAddedMessage)));
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.eightiary,
        title: Text(loc.lessonScreenTitle, style: AppTextStyles.titlesW),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: loc.titleLabelADD),
            ),
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: loc.contentLabelADD),
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: loc.dateLabelADD),
            ),
            TextField(
              controller: categoryIdController,
              decoration: InputDecoration(labelText: loc.categoryIdLabel),
            ),
            Row(
              children: [
                Text(loc.completedLabelADD),
                Checkbox(
                  value: state,
                  onChanged: (val) => setState(() => state = val ?? false),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _addLesson,
              style: ButtonStyles.elevatedbutton4,
              child: Text(loc.saveButtonADD, style: AppTextStyles.button3),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () => context.go('/viewLessons'),
              style: ButtonStyles.elevatedbutton1,
              child: const Text('Ver Lecciones', style: AppTextStyles.button3),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                context.go('/mainmenu');
              },
              style: ButtonStyles.elevatedbutton3,
              child: Text(loc.backButtonADD, style: AppTextStyles.button3),
            ),
          ],
        ),
      ),
    );
  }
}
