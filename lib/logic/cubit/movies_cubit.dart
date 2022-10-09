import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:cinemastation/data/api/movies_webservice.dart';
import 'package:cinemastation/data/model/movie_model.dart';
import 'package:cinemastation/data/repositories/movies_repo.dart';

part 'movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  final MoviesRepo moviesRepo;
  final MoviesWebService moviesWebService;
  MoviesCubit(
    this.moviesRepo,
    this.moviesWebService,
  ) : super(MoviesInitial());

  Future<void> retrieveProducts() async {
    await moviesRepo.retrieveMovies().then((response) {
      if (response.toString() == {}.toString()) {
        emit(MoviesError('Check your internet connection'));
      } else {
        emit(MoviesInitial());
        emit(MoviesRetrieved(response));
      }
    });
  }

  Future<void> toogleFav(String id, bool oldStatus) async {
    await moviesWebService.toggleFavoutires(id, oldStatus).then((response) {
      if (response) {
        emit(MoviesInitial());
        emit(FavToggled('Favourite data changes successfully'));
      } else {
        emit(FavRemoved(response.toString()));
      }
    });
  }

  Future<void> removeFav(String id) async {
    await moviesWebService.removeFavourite(id).then((response) {
      if (response) {
        emit(MoviesInitial());
        emit(FavRemoved('Movie removed from favourites'));
      } else {
        emit(FavRemoved(response.toString()));
      }
    });
  }

  MovieModel findByid(String id) {
    return moviesRepo.findById(id);
  }

  List<MovieModel> getMovie() {
    return moviesRepo.movies;
  }
}
