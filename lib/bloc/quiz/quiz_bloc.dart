import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_app/api/quiz_api.dart';
import 'package:quiz_app/constants/error_constants.dart';
import 'package:quiz_app/model/question_model.dart';
import 'package:quiz_app/services/sqlite_service.dart';

part 'quiz_event.dart';

part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc({QuizApi? quizApi, SqliteService? localDbService}) : super(QuizInitial()) {
    _quizApi = quizApi ?? QuizApi();
    _localDbService = localDbService ?? SqliteService();
    log('QuizApi: $_quizApi | local db: $_localDbService');

    on<FetchQuestions>(_onFetchQuestions);
    on<SelectOption>(_onSelectOption);
    on<SubmitAnswer>(_onSubmitAnswer);
    on<ResetData>(_onResetData);
  }

  QuizApi? _quizApi;
  SqliteService? _localDbService;
  int currentIndex = 0;
  int currentScore = 0;

  void _onFetchQuestions(FetchQuestions event, Emitter<QuizState> emit) async {
    emit(QuestionsLoading());
    try {
      final localResult = await _localDbService!.getQuestions();
      if (localResult.isEmpty) {
        final questions = await _quizApi!.fetchQuestions();
        _localDbService!.storeQuestions(questions);
        emit(
          QuestionsLoaded(
            questions: questions,
            currentIndex: currentIndex,
            currentScore: currentScore,
          ),
        );
      } else {
        emit(
          QuestionsLoaded(
            questions: localResult,
            currentIndex: currentIndex,
            currentScore: currentScore,
          ),
        );
      }
    } on Exception catch (e) {
      log('Error: $e');
      if (e is DioException) {
        emit(
          QuizError(
            e.type == DioExceptionType.connectionError
                ? ErrorConstants.connectionError
                : ErrorConstants.somethingWentWrong,
          ),
        );
      } else {
        emit(const QuizError(ErrorConstants.somethingWentWrong));
      }
    }
  }

  void _onSelectOption(SelectOption event, Emitter<QuizState> emit) {
    emit((state as QuestionsLoaded).copyWith(
      currentSelectedOption: event.option,
      showContinue: true,
    ));
  }

  void _onSubmitAnswer(SubmitAnswer event, Emitter<QuizState> emit) {
    final loadedState = state as QuestionsLoaded;
    if (loadedState.currentSelectedOption ==
        loadedState.questions[currentIndex].answer) {
      currentScore++;
    }
    currentIndex++;

    log('Current score: $currentScore | index: $currentIndex');
    emit(loadedState.copyWith(
      currentIndex: currentIndex,
      currentScore: currentScore,
      showContinue: false,
    ));
  }

  void _onResetData(ResetData event, Emitter<QuizState> emit) {
    currentIndex = 0;
    currentScore = 0;
    emit(QuizInitial());
  }

  @override
  void onTransition(Transition<QuizEvent, QuizState> transition) {
    log(transition.toString());
    super.onTransition(transition);
  }
}
