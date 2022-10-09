import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:cinemastation/data/api/reservation_webservice.dart';
import 'package:cinemastation/data/model/reservation_model.dart';
import 'package:cinemastation/data/model/seats_model.dart';
import 'package:cinemastation/data/repositories/reservation_repo.dart';

part 'reservation_state.dart';

class ReservationCubit extends Cubit<ReservationState> {
  final ReservationWebservice reservationWebservice;

  final ReservationRepo reservationRepo;

  ReservationCubit(
    this.reservationWebservice,
    this.reservationRepo,
  ) : super(ReservationInitial());

  Future<void> addReservation(
      String movieId,
      String movieName,
      String movieDate,
      String movieTime,
      List<SeatModel> reservedSeats,
      String imageName,
      String ticketId) async {
    await reservationWebservice
        .addMovieReservation(movieId, movieName, movieDate, movieTime,
            reservedSeats, imageName, ticketId)
        .then((response) {
      if (response) {
        emit(ReservationAdded('your data has been added successfully'));
      } else {
        emit(ReservationError(response.toString()));
      }
    });
  }

  Future<void> retrieveTicketData() async {
    await reservationRepo.retrieveMoviesStatusData().then((data) {
      if (data.toString() == {}.toString()) {
        emit(ReservationError('Something went wrong please try again later'));
      } else {
        emit(ReservationInitial());
        emit(ReservationRetrieved(data));
      }
    });
  }
}
