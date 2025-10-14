import 'package:flutter/material.dart';

import '../../db/SKDataBase.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:skillsync/core/theme/app_layouts.dart';
import 'package:skillsync/core/theme/text_styles.dart';
import "package:skillsync/core/theme/app_colors.dart";

class TopicScreen extends StatefulWidget {
  const TopicScreen({super.key});

  @override
  State<TopicScreen> createState() => _TopicScreen();
}

class _TopicScreen extends State<TopicScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  bool isCompleted = false;

  Future<void> _addTopic() async {
    final loc = AppLocalizations.of(context)!;
    if (titleController.text.isEmpty ||
        contentController.text.isEmpty ||
        dateController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.missingDataMessageADD)));
    }
    final db = await AppDatabase.initDB();
    await db.insert('topic', {
      'title': titleController.text,
      'content': contentController.text,
      'date': dateController.text,
      'state': isCompleted ? 1 : 0,
    });
    titleController.clear(); //limpia el campo para poder agregar uno nuevo
    contentController.clear();
    dateController.clear();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(loc.topicAddedMessageADD)));
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.topicScreenTitleADD),
        backgroundColor: AppColors.boldcolor,
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

            Row(
              children: [
                Text(loc.completedLabelADD),
                Checkbox(
                  value: isCompleted,
                  onChanged:
                      (val) => setState(() => isCompleted = val ?? false),
                ),
              ],
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: _addTopic,
              style: ButtonStyles.elevatedbutton4,
              child: Text(loc.saveButtonADD, style: AppTextStyles.button3),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () => context.go('/viewTopics'),
              style: ButtonStyles.elevatedbutton1,
              child: Text(
                loc.viewTopicsButtonADD,
                style: AppTextStyles.button3,
              ),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () => context.go('/mainmenu'),
              style: ButtonStyles.elevatedbutton3,
              child: Text(loc.backButtonADD, style: AppTextStyles.button3),
            ),
          ],
        ),
      ),
    );
  }
}
