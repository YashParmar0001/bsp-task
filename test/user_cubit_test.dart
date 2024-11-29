import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_app/bloc/user/user_cubit.dart';
import 'package:quiz_app/constants/fields_constants.dart';
import 'package:quiz_app/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;

  setUpAll(() {
    registerFallbackValue(UserModel.zero());
  });

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    SharedPreferences.setMockInitialValues({});
  });

  group('UserCubit Tests', () {
    blocTest<UserCubit, UserState>(
      'emits [UserDataLoding, UserDataLoaded] when user data is fetched successfully',
      build: () {
        when(() => mockSharedPreferences.getInt(FieldsConstants.score) ?? 10)
            .thenReturn(10);
        when(() => mockSharedPreferences.getInt(FieldsConstants.quizCompleted) ?? 5)
            .thenReturn(5);

        return UserCubit(sharedPrefs: mockSharedPreferences);
      },
      act: (bloc) => bloc.fetchUserData(),
      expect: () => [
        UserDataLoading(),
        UserDataLoaded(
          const UserModel(
            score: 10,
            quizCompleted: 5,
          ),
        ),
      ],
    );

    blocTest<UserCubit, UserState>(
      'emits [UserDataLoaded] with updated score and quiz count when updateData is called',
      build: () {
        when(() => mockSharedPreferences.getInt(FieldsConstants.score))
            .thenReturn(10);
        when(() => mockSharedPreferences.getInt(FieldsConstants.quizCompleted))
            .thenReturn(5);
        when(() => mockSharedPreferences.setInt(any(), any()))
            .thenAnswer((_) async => true);

        return UserCubit(sharedPrefs: mockSharedPreferences);
      },
      act: (cubit) async {
        await cubit.updateData(score: 15);
      },
      expect: () => [
        UserDataLoaded(
          const UserModel(
            score: 25,
            quizCompleted: 6,
          ),
        ),
      ],
    );

    blocTest<UserCubit, UserState>(
      'emits [UserDataLoaded] with only updated quiz count when updateData is called without score',
      build: () {
        when(() => mockSharedPreferences.getInt(FieldsConstants.score))
            .thenReturn(10);
        when(() => mockSharedPreferences.getInt(FieldsConstants.quizCompleted))
            .thenReturn(5);
        when(() => mockSharedPreferences.setInt(any(), any()))
            .thenAnswer((_) async => true);

        return UserCubit(sharedPrefs: mockSharedPreferences);
      },
      act: (cubit) async {
        await cubit.updateData(score: null);
      },
      expect: () => [
        UserDataLoaded(
          const UserModel(
            score: 10,
            quizCompleted: 6,
          ),
        ),
      ],
    );
  });
}
