import 'dart:convert';
import 'dart:developer';

import 'package:quiz_app/constants/api_constants.dart';

import '../model/question_model.dart';
import 'package:dio/dio.dart';

class QuizApi {
  final _dio = Dio();

  Future<List<QuestionModel>> fetchQuestions() async {
    try {
      final response = await _dio.get(ApiConstants.url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.data) as Map<String, dynamic>;
        final questions = data['DATA']['questions'] as List<dynamic>;
        return questions.map((e) => QuestionModel.fromMap(e)).toList();
      } else {
        throw Exception('Something went wrong!');
      }
    } catch (e) {
      log('Error: $e');
      rethrow;
    }
  }
}
