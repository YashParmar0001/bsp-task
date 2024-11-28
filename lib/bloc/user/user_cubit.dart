import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:quiz_app/constants/fields_constants.dart';
import 'package:quiz_app/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial()) {
    log('Constructor called');
    fetchUserData();
  }

  void fetchUserData() async {
    log('Fetching user data');
    emit(UserDataLoading());
    final prefs = await SharedPreferences.getInstance();
    emit(
      UserDataLoaded(
        UserModel(
          score: prefs.getInt(FieldsConstants.score) ?? 0,
          quizCompleted: prefs.getInt(FieldsConstants.quizCompleted) ?? 0,
        ),
      ),
    );
  }

  Future<void> updateData({int? score, bool incrementQuizCount = true}) async {
    final prefs = await SharedPreferences.getInstance();
    final oldUser = getUser();
    int quizCompleted = oldUser.quizCompleted;
    int newScore = oldUser.score + (score ?? 0);
    if (incrementQuizCount) {
      quizCompleted++;
    }

    if (score != null) {
      await prefs.setInt(FieldsConstants.score, newScore);
    }
    if (incrementQuizCount) {
      await prefs.setInt(
        FieldsConstants.quizCompleted,
        quizCompleted,
      );
    }

    emit(
      UserDataLoaded(
        UserModel(
          score: newScore,
          quizCompleted: quizCompleted,
        ),
      ),
    );
  }

  UserModel getUser() {
    if (state is UserDataLoaded) {
      log('Loaded user');
      return (state as UserDataLoaded).user;
    } else {
      log('Zero user');
      return UserModel.zero();
    }
  }

  @override
  void onChange(Change<UserState> change) {
    log(change.toString());
    super.onChange(change);
  }
}
