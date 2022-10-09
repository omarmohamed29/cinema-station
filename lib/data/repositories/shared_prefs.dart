import 'dart:convert';

// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';

class Sharedprefs {
  initializePrefs() async {
    await SharedPreferences.getInstance();
  }

  toMap(String token, String userid, String expiryDate, String refreshToken) {
    final data = json.encode({
      'token': token,
      'userId': userid,
      'expiresIn': expiryDate,
      'refresh_token': refreshToken,
    });
    return data;
  }

  Future<void> saveData(String userData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', userData);
  }

  Future<Map<String, dynamic>> retrieveData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return {};
    } else {
      final data = json.decode(prefs.getString('userData').toString());
      return data;
    }
  }

  Future<void> deleteData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
