import 'package:cinemastation/data/api/movie_status_webservice.dart';
import 'package:cinemastation/data/model/movie_status_model.dart';
import 'package:cinemastation/data/model/seats_model.dart';

class MovieStatusRepo {
  final MovieStatusWebService movieStatusWebService;

  MovieStatusRepo(
    this.movieStatusWebService,
  );

  List<MovieStatusModel> _movieStatus = [];

  List<MovieStatusModel> get seatsStatus {
    return [..._movieStatus];
  }

  Future<dynamic> retrieveMoviesStatusData(
    String movieId,
  ) async {
    final retrieveMovies =
        await movieStatusWebService.retrieveMoviesStatusData(movieId);
    if (retrieveMovies.isEmpty) {
      return {};
    } else {
      List<MovieStatusModel> retrievedMovies = [];

      retrieveMovies.forEach((movieId, moviesData) {
        retrievedMovies.add(MovieStatusModel(
          movieId: movieId,
          movieName: moviesData['movieName'],
          movieDate: moviesData['movieDate'],
          movieTime: moviesData['movieTime'],
          returnedSeats: (moviesData['reservedSeats'] as List<dynamic>)
              .map((seatR) => SeatModel(
                    verticalPoint: seatR['vertical'],
                    horizontalPoint: seatR['horizontal'],
                    seatName: seatR['seatName'],
                    status: seatR['status'],
                  ))
              .toList(),
        ));
      });
      _movieStatus = retrievedMovies.toList();
      return _movieStatus;
    }
  }
}
