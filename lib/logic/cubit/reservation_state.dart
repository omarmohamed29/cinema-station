part of 'reservation_cubit.dart';

@immutable
abstract class ReservationState {}

class ReservationInitial extends ReservationState {}

class ReservationAdded extends ReservationState {
  final String response;

  ReservationAdded(this.response);
}

class ReservationError extends ReservationState {
  final String response;

  ReservationError(this.response);
}

class ReservationRetrieved extends ReservationState {
  final List<ReservationModel> reservation;

  ReservationRetrieved(this.reservation);
}
