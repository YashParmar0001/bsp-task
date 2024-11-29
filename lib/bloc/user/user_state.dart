part of 'user_cubit.dart';

sealed class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class UserInitial extends UserState {}

final class UserDataLoading extends UserState {}

final class UserDataLoaded extends UserState {
  UserDataLoaded(this.user);

  final UserModel user;

  @override
  List<Object?> get props => [user.score, user.quizCompleted];
}
