import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class AppDatabase {
  static Future<Database> initDB() async {
    final pathdb = await getDatabasesPath();
    final path = join(pathdb, 'skillsync.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            level TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE category (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            date TEXT,
            lesson_count INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE lesson (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            date TEXT,
            state BOOLEAN,
            user_id INTEGER,
            category_id INTEGER,
            FOREIGN KEY (user_id) REFERENCES user(id),
            FOREIGN KEY (category_id) REFERENCES category(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE weekly_objective (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            description TEXT,
            date TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE reminder (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            message TEXT,
            date TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE stats (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category_id INTEGER,
            category_title TEXT,
            user_name TEXT,
            total_lessons INTEGER,
            FOREIGN KEY (category_id) REFERENCES category(id),
            FOREIGN KEY (user_name) REFERENCES user(name)
          )
        ''');
      },
    );
  }
}
