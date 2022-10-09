import 'dart:convert';

import 'package:cinemastation/data/model/seats_model.dart';
import 'package:cinemastation/data/repositories/shared_prefs.dart';

import 'package:http/http.dart' as http;

class MovieStatusWebService {
  final Sharedprefs sharedprefs;

  MovieStatusWebService(this.sharedprefs);

  Future<bool> addMovieStatus(
    String movieId,
    String movieName,
    String movieDate,
    String movieTime,
    List<SeatModel> reservedSeats,
  ) async {
    final prefs = await sharedprefs.retrieveData();
    final token = prefs['token'];
    final url =
        "https://cinema-station-default-rtdb.firebaseio.com/MovieStatus/$movieId.json?auth=$token";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'movieId': movieId,
          'movieName': movieName,
          'movieDate': movieDate,
          'movieTime': movieTime,
          'reservedSeats': reservedSeats
              .map((e) => {
                    'vertical': e.verticalPoint,
                    'horizontal': e.horizontalPoint,
                    'seatName': e.seatName,
                    'status': true,
                  })
              .toList()
        }),
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

  Future<Map<String, dynamic>> retrieveMoviesStatusData(
    String movieId,
  ) async {
    final allPrefs = await sharedprefs.retrieveData();
    final token = allPrefs['token'];

    final url =
        "https://cinema-station-default-rtdb.firebaseio.com/MovieStatus/$movieId.json?auth=$token";
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
}
