import 'dart:convert';

import 'package:cinemastation/data/model/seats_model.dart';
import 'package:cinemastation/data/repositories/shared_prefs.dart';
import 'package:http/http.dart' as http;

class ReservationWebservice {
  final Sharedprefs sharedprefs;

  ReservationWebservice(this.sharedprefs);

  Future<bool> addMovieReservation(
      String movieId,
      String movieName,
      String movieDate,
      String movieTime,
      List<SeatModel> reservedSeats,
      String imageName,
      String ticketId) async {
    final prefs = await sharedprefs.retrieveData();
    final token = prefs['token'];
    final uid = prefs['userId'];
    final url =
        "https://cinema-station-default-rtdb.firebaseio.com/Reservations/$uid.json?auth=$token";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'customerId': uid,
          'movieId': movieId,
          'movieName': movieName,
          'movieDate': movieDate,
          'movieTime': movieTime,
          'imageName': imageName,
          'ticketId': ticketId,
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

  Future<Map<String, dynamic>> retrieveMoviesStatusData() async {
    final allPrefs = await sharedprefs.retrieveData();
    final token = allPrefs['token'];
    final uid = allPrefs['userId'];

    final url =
        "https://cinema-station-default-rtdb.firebaseio.com/Reservations/$uid.json?auth=$token";

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
