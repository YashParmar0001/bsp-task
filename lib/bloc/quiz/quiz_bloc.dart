import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:quiz_app/api/quiz_api.dart';
import 'package:quiz_app/model/question_model.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(QuizInitial()) {
    on<FetchQuestions>(_onFetchQuestions);
  }

  final _quizApi = QuizApi();

  void _onFetchQuestions(FetchQuestions event, Emitter<QuizState> emit) async {
    emit(QuestionsLoading());
    try {
      final questions = await _quizApi.fetchQuestions();
      emit(QuestionsLoaded(questions));
    } on Exception catch (e) {
      emit(QuizError(e.toString()));
    }
  }
}
