part of 'quiz_bloc.dart';

sealed class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

final class QuizInitial extends QuizState {}

final class QuestionsLoading extends QuizState {}

final class QuestionsLoaded extends QuizState {
  const QuestionsLoaded({
    required this.questions,
    required this.currentIndex,
    required this.currentScore,
    this.currentSelectedOption,
    this.showContinue = false,
  });

  final List<QuestionModel> questions;
  final int currentScore;
  final int currentIndex;
  final String? currentSelectedOption;
  final bool showContinue;

  QuestionsLoaded copyWith({
    int? currentScore,
    int? currentIndex,
    String? currentSelectedOption,
    bool? showContinue,
  }) {
    return QuestionsLoaded(
      questions: questions,
      currentIndex: currentIndex ?? this.currentIndex,
      currentScore: currentScore ?? this.currentScore,
      currentSelectedOption:
          currentSelectedOption ?? this.currentSelectedOption,
      showContinue: showContinue ?? this.showContinue,
    );
  }

  @override
  List<Object?> get props => [
        questions,
        currentScore,
        currentIndex,
        currentSelectedOption,
      ];
}

final class QuizError extends QuizState {
  const QuizError(this.message);

  final String message;
}
