import 'package:bloc/bloc.dart';
import 'package:cinemastation/data/model/seats_model.dart';
import 'package:meta/meta.dart';

import 'package:cinemastation/data/api/movie_status_webservice.dart';
import 'package:cinemastation/data/model/movie_status_model.dart';
import 'package:cinemastation/data/repositories/movie_status_repo.dart';

part 'movie_status_state.dart';

class MovieStatusCubit extends Cubit<MovieStatusState> {
  final MovieStatusWebService movieStatusWebService;
  final MovieStatusRepo movieStatusRepo;
  MovieStatusCubit(
    this.movieStatusWebService,
    this.movieStatusRepo,
  ) : super(MovieStatusInitial());

  Future<void> addMovieStatus(
    String movieId,
    String movieName,
    String movieDate,
    String movieTime,
    List<SeatModel> reservedSeats,
  ) async {
    await movieStatusWebService
        .addMovieStatus(movieId, movieName, movieDate, movieTime, reservedSeats)
        .then((response) {
      if (response) {
        emit(MovieStatusAdded('your data has been added successfully'));
      } else {
        emit(MovieStatusError(response.toString()));
      }
    });
  }

  Future<void> retrieveMovieStatus(String movieId) async {
    await movieStatusRepo.retrieveMoviesStatusData(movieId).then((data) {
      if (data.toString() == {}.toString()) {
        emit(MovieStatusError('Something went wrong please try again later'));
      } else {
        emit(MovieStatusInitial());
        emit(MovieStatusRetrieved(data));
      }
    });
  }
}
