part of 'quiz_bloc.dart';

sealed class QuizEvent {
  const QuizEvent();
}

class FetchQuestions extends QuizEvent {}
