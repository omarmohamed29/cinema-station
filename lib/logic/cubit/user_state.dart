part of 'user_cubit.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserRetrieved extends UserState {
  final User user;

  UserRetrieved(this.user);
}

class UserAdded extends UserState {
  final String response;

  UserAdded(this.response);
}

class UserEdited extends UserState {
  final String response;

  UserEdited(this.response);
}

class UserProfileEdited extends UserState {
  final String response;

  UserProfileEdited(this.response);
}

class UserError extends UserState {
  final String response;

  UserError(this.response);
}
