part of 'movie_status_cubit.dart';

@immutable
abstract class MovieStatusState {}

class MovieStatusInitial extends MovieStatusState {}

class MovieStatusAdded extends MovieStatusState {
  final String response;

  MovieStatusAdded(this.response);
}

class MovieStatusError extends MovieStatusState {
  final String response;

  MovieStatusError(this.response);
}

class MovieStatusRetrieved extends MovieStatusState {
  final List<MovieStatusModel> movieStatus;

  MovieStatusRetrieved(this.movieStatus);
}
