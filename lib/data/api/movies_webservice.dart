import 'dart:convert';

import '../repositories/shared_prefs.dart';
import 'package:http/http.dart' as http;

class MoviesWebService {
  final Sharedprefs sharedprefs;

  MoviesWebService(this.sharedprefs);
  Future<Map<String, dynamic>> retrieveMoviesData() async {
    final allPrefs = await sharedprefs.retrieveData();
    final token = allPrefs['token'];

    final url =
        'https://cinema-station-default-rtdb.firebaseio.com/Movie.json?auth=$token';
    try {
      final response = await http.get(Uri.parse(url));

      final data = json.decode(response.body);
      if (data != null) {
        return data;
      } else {
        return {};
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> retrieveFavMoviesData() async {
    final allPrefs = await sharedprefs.retrieveData();
    final token = allPrefs['token'];
    final uid = allPrefs['userId'];

    final url =
        'https://cinema-station-default-rtdb.firebaseio.com/userFavourites/$uid.json?auth=$token';
    try {
      final response = await http.get(Uri.parse(url));

      final data = json.decode(response.body);
      if (data != null) {
        return data;
      } else {
        return {};
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> toggleFavoutires(String id, bool oldStatus) async {
    final allPrefs = await sharedprefs.retrieveData();
    final token = allPrefs['token'];
    final uid = allPrefs['userId'];
    final url =
        'https://cinema-station-default-rtdb.firebaseio.com/userFavourites/$uid/$id.json?auth=$token';

    oldStatus = !oldStatus;

    try {
      final response =
          await http.put(Uri.parse(url), body: jsonEncode(oldStatus));

      if (response.statusCode >= 400) {
        return false;
      } else {
        return true;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> removeFavourite(String id) async {
    final allPrefs = await sharedprefs.retrieveData();
    final token = allPrefs['token'];
    final uid = allPrefs['userId'];

    final url =
        'https://cinema-station-default-rtdb.firebaseio.com/userFavourites/$uid/$id.json?auth=$token';

    try {
      final response = await http.delete(
        Uri.parse(url),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      rethrow;
    }
  }
}
