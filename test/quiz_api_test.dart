import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/api/quiz_api.dart';
import 'package:quiz_app/model/question_model.dart';

void main() {
  late QuizApi api;

  setUp(() {
    api = QuizApi();
  });

  test('API call will return list of questions if success', () async {
    final result = await api.fetchQuestions();

    expect(List<QuestionModel>, result.runtimeType);
  });
}
