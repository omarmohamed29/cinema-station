part of 'movies_cubit.dart';

@immutable
abstract class MoviesState {}

class MoviesInitial extends MoviesState {}

class MoviesError extends MoviesState {
  final String error;

  MoviesError(this.error);
}

class MoviesDataAdded extends MoviesState {
  final String response;

  MoviesDataAdded(this.response);
}

class MoviesDataUpdated extends MoviesState {
  final String response;

  MoviesDataUpdated(this.response);
}

class MoviesRetrieved extends MoviesState {
  final List<MovieModel> movies;

  MoviesRetrieved(this.movies);
}

class FavToggled extends MoviesState {
  final String response;

  FavToggled(this.response);
}

class FavRemoved extends MoviesState {
  final String response;

  FavRemoved(this.response);
}
