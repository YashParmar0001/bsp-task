part of 'user_cubit.dart';

sealed class UserState {}

final class UserInitial extends UserState {}

final class UserDataLoading extends UserState {}

final class UserDataLoaded extends UserState {
  UserDataLoaded(this.user);

  final UserModel user;
}
