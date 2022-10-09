import 'available_dates_model.dart';

class MovieModel {
  late final String? id;
  late final String? title;
  late final String? description;
  late final String? imageName;
  late final String? rate;
  late final String? categories;
  late final String? duration;
  late final List<AvailableDates>? movieDate;
  late final int? numOfSeats = 47;
  late bool isFavourite;

  MovieModel({
    this.id,
    this.title,
    this.description,
    this.imageName,
    this.rate,
    this.categories,
    this.duration,
    this.movieDate,
    this.isFavourite = false,
  });
}
