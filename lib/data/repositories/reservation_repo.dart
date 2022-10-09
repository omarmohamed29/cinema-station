import 'package:cinemastation/data/api/reservation_webservice.dart';
import 'package:cinemastation/data/model/reservation_model.dart';
import 'package:cinemastation/data/model/seats_model.dart';

class ReservationRepo {
  final ReservationWebservice reservationWebservice;

  ReservationRepo(this.reservationWebservice);

  List<ReservationModel> _reservation = [];

  List<ReservationModel> get reservation {
    return [..._reservation];
  }

  Future<dynamic> retrieveMoviesStatusData() async {
    final retrievedStatus =
        await reservationWebservice.retrieveMoviesStatusData();
    if (retrievedStatus.isEmpty) {
      return {};
    } else {
      List<ReservationModel> retrievedMoviesStatus = [];

      retrievedStatus.forEach((movieId, moviesData) {
        retrievedMoviesStatus.add(ReservationModel(
          customerId: moviesData['customerId'],
          movieId: moviesData['movieId'],
          movieName: moviesData['movieName'],
          movieDate: moviesData['movieDate'],
          movieTime: moviesData['movieTime'],
          imageName: moviesData['imageName'],
          ticketId: moviesData['ticketId'],
          reservedSeats: (moviesData['reservedSeats'] as List<dynamic>)
              .map((seatR) => SeatModel(
                    verticalPoint: seatR['vertical'],
                    horizontalPoint: seatR['horizontal'],
                    seatName: seatR['seatName'],
                    status: seatR['status'],
                  ))
              .toList(),
        ));
      });
      _reservation = retrievedMoviesStatus.toList();
      return _reservation;
    }
  }
}
