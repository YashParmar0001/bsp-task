part of 'quiz_bloc.dart';

sealed class QuizEvent {
  const QuizEvent();
}

class FetchQuestions extends QuizEvent {}

class SelectOption extends QuizEvent {
  const SelectOption(this.option);

  final String option;
}

class SubmitAnswer extends QuizEvent {}

class ResetData extends QuizEvent {}
