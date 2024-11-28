part of 'quiz_bloc.dart';

sealed class QuizState {
  const QuizState();
}

final class QuizInitial extends QuizState {}

final class QuestionsLoading extends QuizState {}

final class QuestionsLoaded extends QuizState {
  const QuestionsLoaded(this.questions);

  final List<QuestionModel> questions;
}

final class QuizError extends QuizState {
  const QuizError(this.message);

  final String message;
}
