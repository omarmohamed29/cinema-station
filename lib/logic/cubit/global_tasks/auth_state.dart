part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthError extends AuthState {
  final String error;
  AuthError({required this.error});
}

class AuthSucceed extends AuthState {
  final Auth authData;
  AuthSucceed({required this.authData});
}

class AuthExists extends AuthState {
  final bool authExist;

  AuthExists({required this.authExist});
}

class IsAuthenticated extends AuthState {}

class NotAuthenticated extends AuthState {}
