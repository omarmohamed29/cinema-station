import 'package:cinemastation/data/api/movies_webservice.dart';
import 'package:cinemastation/data/model/available_dates_model.dart';
import 'package:cinemastation/data/model/movie_model.dart';

class MoviesRepo {
  final MoviesWebService moviesWebService;
  List<MovieModel> _movies = [];

  List<MovieModel> get movies {
    return [..._movies];
  }

  MoviesRepo(this.moviesWebService);

  Future<dynamic> retrieveMovies() async {
    final retrieveMovies = await moviesWebService.retrieveMoviesData();
    final retrieveFavMovies = await moviesWebService.retrieveFavMoviesData();
    if (retrieveMovies.isEmpty) {
      return {};
    } else {
      List<MovieModel> retrievedMovies = [];
      final favouriteData = retrieveFavMovies;
      retrieveMovies.forEach((movieId, moviesData) {
        retrievedMovies.add(MovieModel(
          id: movieId,
          title: moviesData['title'],
          description: moviesData['description'],
          imageName: moviesData['imageName'],
          categories: moviesData['category'],
          duration: moviesData['duration'],
          rate: moviesData['rate'],
          isFavourite:
              favouriteData == {} ? false : favouriteData[movieId] ?? false,
          movieDate: (moviesData['movieDate'] as List<dynamic>)
              .map((dateM) => AvailableDates(
                  first: dateM['first'],
                  second: dateM['second'],
                  third: dateM['third'],
                  fourth: dateM['fourth']))
              .toList(),
        ));
      });
      _movies = retrievedMovies;
      return _movies;
    }
  }

  MovieModel findById(String id) {
    return _movies.firstWhere((element) => element.id == id);
  }
}
