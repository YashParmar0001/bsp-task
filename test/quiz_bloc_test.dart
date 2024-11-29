import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_app/api/quiz_api.dart';
import 'package:quiz_app/bloc/quiz/quiz_bloc.dart';
import 'package:quiz_app/constants/error_constants.dart';
import 'package:quiz_app/model/question_model.dart';
import 'package:quiz_app/services/sqlite_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MockQuizApi extends Mock implements QuizApi {}

class MockSqliteService extends Mock implements SqliteService {}

void main() {
  late MockQuizApi mockQuizApi;
  late MockSqliteService mockSqliteService;

  const dummyQuestion = QuestionModel(
    id: 1,
    question: "What is Flutter?",
    options: ["SDK", "Framework", "Language", "Tool"],
    answer: "SDK",
  );

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    registerFallbackValue(<QuestionModel>[]);
    mockQuizApi = MockQuizApi();
    mockSqliteService = MockSqliteService();
  });

  group('QuizBloc Tests', () {
    blocTest<QuizBloc, QuizState>(
      'emits [QuestionsLoading, QuestionsLoaded] when FetchQuestions is successful with API data',
      build: () {
        when(() => mockSqliteService.getQuestions())
            .thenAnswer((_) async => <QuestionModel>[]);
        when(() => mockQuizApi.fetchQuestions())
            .thenAnswer((_) async => <QuestionModel>[]);
        when(() => mockSqliteService.storeQuestions([])).thenAnswer(
          (_) async {},
        );
        return QuizBloc(
          quizApi: mockQuizApi,
          localDbService: mockSqliteService,
        );
      },
      act: (bloc) => bloc.add(FetchQuestions()),
      wait: const Duration(seconds: 1),
      expect: () => [
        QuestionsLoading(),
        const QuestionsLoaded(
          questions: <QuestionModel>[],
          currentIndex: 0,
          currentScore: 0,
        ),
      ],
    );

    blocTest<QuizBloc, QuizState>(
      'emits [QuestionsLoading, QuestionsLoaded] when FetchQuestions is successful with local DB data',
      build: () {
        when(() => mockSqliteService.getQuestions()).thenAnswer(
          (_) async => [
            dummyQuestion,
          ],
        );
        return QuizBloc(
          quizApi: mockQuizApi,
          localDbService: mockSqliteService,
        );
      },
      act: (bloc) => bloc.add(FetchQuestions()),
      expect: () => [
        QuestionsLoading(),
        const QuestionsLoaded(
          questions: [
            dummyQuestion,
          ],
          currentIndex: 0,
          currentScore: 0,
        ),
      ],
    );

    blocTest<QuizBloc, QuizState>(
      'emits QuizError when FetchQuestions encounters a Dio connection error',
      build: () {
        when(() => mockSqliteService.getQuestions())
            .thenAnswer((_) async => []);
        when(() => mockQuizApi.fetchQuestions()).thenThrow(DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: ''),
        ));
        return QuizBloc(
          quizApi: mockQuizApi,
          localDbService: mockSqliteService,
        );
      },
      act: (bloc) => bloc.add(FetchQuestions()),
      expect: () => [
        QuestionsLoading(),
        const QuizError(ErrorConstants.connectionError),
      ],
    );

    blocTest<QuizBloc, QuizState>(
      'emits updated QuestionsLoaded when SelectOption is added',
      build: () {
        return QuizBloc(
          quizApi: mockQuizApi,
          localDbService: mockSqliteService,
        );
      },
      seed: () => const QuestionsLoaded(
        questions: [dummyQuestion],
        currentIndex: 0,
        currentScore: 0,
      ),
      act: (bloc) => bloc.add(const SelectOption("SDK")),
      expect: () => [
        const QuestionsLoaded(
          questions: [dummyQuestion],
          currentIndex: 0,
          currentScore: 0,
          currentSelectedOption: "SDK",
          showContinue: true,
        ),
      ],
    );

    blocTest<QuizBloc, QuizState>(
      'emits updated QuestionsLoaded when SubmitAnswer is added',
      build: () {
        return QuizBloc(
          quizApi: mockQuizApi,
          localDbService: mockSqliteService,
        );
      },
      seed: () => const QuestionsLoaded(
        questions: [dummyQuestion],
        currentIndex: 0,
        currentScore: 0,
        currentSelectedOption: "SDK",
      ),
      act: (bloc) => bloc.add(SubmitAnswer()),
      expect: () => [
        const QuestionsLoaded(
          questions: [dummyQuestion],
          currentIndex: 1,
          currentScore: 1,
          currentSelectedOption: "SDK",
          showContinue: false,
        ),
      ],
    );
  });
}
