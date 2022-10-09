import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cinemastation/data/repositories/shared_prefs.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/model/auth_model.dart';
import '../../../data/repositories/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  final Sharedprefs sharedprefs;
  Timer? _authTimer;
  late DateTime timeToExpiry;

  Auth auth = Auth(token: '', userId: '', expiryDate: '', refreshToken: '');
  AuthCubit(this.authRepo, this.sharedprefs) : super(AuthInitial());

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    await authRepo.authenticate(email, password, urlSegment).then((auth) {
      if (auth.toString().contains('EMAIL_EXISTS')) {
        emit(AuthError(error: 'This email address is already in use. '));
      } else if (auth.toString().contains('INVALID_EMAIL')) {
        emit(AuthError(error: 'This is not a valid email address. '));
      } else if (auth.toString().contains('WEAK_PASSWORD')) {
        emit(AuthError(error: 'This password is too weak.  '));
      } else if (auth.toString().contains('EMAIL_NOT_FOUND')) {
        emit(AuthError(error: 'Could not find a user with that email. '));
      } else if (auth.toString().contains('INVALID_PASSWORD')) {
        emit(AuthError(error: 'INVALID PASSWORD '));
      } else {
        emit(AuthSucceed(authData: auth));
        final authData = auth as Auth;
        inspect(authData);
        timeToExpiry = DateTime.now()
            .add(Duration(seconds: int.parse(authData.expiryDate)));
        final shared = sharedprefs.toMap(authData.token, authData.userId,
            timeToExpiry.toIso8601String(), authData.refreshToken);
        sharedprefs.saveData(shared);
        autoLogout();
      }
    });
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      emit(AuthInitial());
      return;
    }
    final allPrefs = await sharedprefs.retrieveData();
    final expiryTime = DateTime.parse(allPrefs['expiresIn']);

    if (expiryTime.isBefore(DateTime.now())) {
      await authRepo.refresh().then((auth) async {
        await sharedprefs.deleteData();
        final authData = auth as Auth;
        timeToExpiry = DateTime.now()
            .add(Duration(seconds: int.parse(authData.expiryDate)));

        final shared = sharedprefs.toMap(authData.token, authData.userId,
            timeToExpiry.toIso8601String(), authData.refreshToken);
        await sharedprefs.saveData(shared);
        autoLogout();
        emit(AuthSucceed(authData: authData));
        return true;
      });
    } else {
      final authData = Auth.toMap(allPrefs);
      timeToExpiry = expiryTime;
      emit(AuthSucceed(authData: authData));
      autoLogout();
    }
  }

  Future<void> logout() async {
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    await sharedprefs.deleteData();
    emit(AuthInitial());
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final expiryTime = timeToExpiry.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: expiryTime), logout);
  }
}
