import 'package:cinemastation/data/model/seats_model.dart';

class MovieStatusModel {
  late final String movieId;
  late final String movieName;
  late final String movieDate;
  late final String movieTime;
  late final List<SeatModel> returnedSeats;
  MovieStatusModel(
      {required this.movieId,
      required this.movieName,
      required this.movieDate,
      required this.movieTime,
      required this.returnedSeats});
}
