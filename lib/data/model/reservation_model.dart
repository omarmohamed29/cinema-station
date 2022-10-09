import 'package:cinemastation/data/model/seats_model.dart';

class ReservationModel {
  late String customerId;

  late String movieId;
  late String movieName;

  late String movieDate;
  late String movieTime;
  late String imageName;
  late String ticketId;
  late List<SeatModel> reservedSeats;

  ReservationModel(
      {required this.customerId,
      required this.movieId,
      required this.movieName,
      required this.movieDate,
      required this.movieTime,
      required this.imageName,
      required this.ticketId,
      required this.reservedSeats});
}
