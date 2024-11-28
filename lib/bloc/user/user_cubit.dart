import 'package:bloc/bloc.dart';
import 'package:quiz_app/constants/fields_constants.dart';
import 'package:quiz_app/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  Future<void> fetchUserData() async {
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

  Future<void> updateData({int? score, int? quizCompleted}) async {
    final prefs = await SharedPreferences.getInstance();

    if (score != null) {
      await prefs.setInt(FieldsConstants.score, score);
    }
    if (quizCompleted != null) {
      await prefs.setInt(FieldsConstants.quizCompleted, quizCompleted);
    }

    final oldUser = getUser();
    emit(
      UserDataLoaded(
        UserModel(
          score: score ?? oldUser.score,
          quizCompleted: quizCompleted ?? oldUser.quizCompleted,
        ),
      ),
    );
  }

  UserModel getUser() {
    if (state is UserDataLoaded) {
      return (state as UserDataLoaded).user;
    } else {
      return UserModel.zero();
    }
  }
}
