import 'dart:async';

import '../api/auth_webservice.dart';
import '../model/auth_model.dart';

class AuthRepo {
  final AuthWebservice authWebservice;
  AuthRepo(this.authWebservice);

  Future<dynamic> authenticate(
      String email, String password, String urlSegment) async {
    final authData =
        await authWebservice.authenticate(email, password, urlSegment);
    if (authData.toString().contains('error')) {
      return authData['error']['message'];
    } else {
      final data = Auth.fromJson(authData);
      return data;
    }
  }

  Future<dynamic> refresh() async {
    final authData = await authWebservice.refreshToken();
    if (authData.toString().contains('error')) {
      return authData['error']['message'];
    } else {
      final data = Auth.refreshToMap(authData);
      return data;
    }
  }
}
