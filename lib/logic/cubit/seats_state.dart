part of 'seats_cubit.dart';

@immutable
abstract class SeatsState {}

class SeatsInitial extends SeatsState {}

class SeatsAddedLocally extends SeatsState {
  final String message;

  SeatsAddedLocally(this.message);
}

class SeatsRemovedLocally extends SeatsState {
  final String message;
  SeatsRemovedLocally({
    required this.message,
  });
}

class SeatsClearedLocally extends SeatsState {}

class SeatsRetrieved extends SeatsState {
  final List<SeatModel> localSeats;

  SeatsRetrieved(this.localSeats);
}
