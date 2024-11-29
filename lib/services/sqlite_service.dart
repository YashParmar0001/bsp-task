import 'dart:developer';

import 'package:path/path.dart';
import 'package:quiz_app/model/question_model.dart';
import 'package:sqflite/sqflite.dart';

class SqliteService {
  Future<Database> initializeDB() async {
    final path = await getDatabasesPath();

    return openDatabase(
      join(path, 'quiz_db.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE questions ("
          "id INTEGER PRIMARY KEY, "
          "question TEXT, "
          "options TEXT, "
          "answer TEXT"
          ")",
        );
      },
    );
  }

  Future<List<QuestionModel>> getQuestions() async {
    print('Getting local questions');
    final db = await initializeDB();

    final result = await db.query('questions');
    return result.map((e) => QuestionModel.fromLocalMap(e)).toList();
  }

  Future<void> storeQuestions(List<QuestionModel> questions) async {
    log('Storing offline');
    for (QuestionModel question in questions) {
      await storeQuestion(question);
    }
  }

  Future<void> storeQuestion(QuestionModel question) async {
    final db = await initializeDB();

    final result = await db.insert('questions', question.toMap());
    log('Stored question: $result');
  }
}
