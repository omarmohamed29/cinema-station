import 'package:http/http.dart' as http;
import 'dart:convert';

import '../repositories/shared_prefs.dart';

class AuthWebservice {
  final Sharedprefs sharedprefs;

  AuthWebservice(this.sharedprefs);

  Future<Map<String, dynamic>> authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCpZFwXxkSRN9tcsiEqNohcS3AvZNpYM8g';
    try {
      final posted = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      // var logger = Logger();
      // logger.d(posted.body);
      final response = json.decode(posted.body);
      return response;
    } catch (error) {
      return {'': ''};
    }
  }

  Future<Map<String, dynamic>> refreshToken() async {
    final prefs = await sharedprefs.retrieveData();

    final refreshToken = prefs['refresh_token'];

    const url =
        'https://securetoken.googleapis.com/v1/token?key=AIzaSyCpZFwXxkSRN9tcsiEqNohcS3AvZNpYM8g';
    try {
      final posted = await http.post(Uri.parse(url),
          body: json.encode({
            "grant_type": "refresh_token",
            "refresh_token": refreshToken,
          }));

      final response = json.decode(posted.body);
      return response;
    } catch (error) {
      return {'': ''};
    }
  }
}
