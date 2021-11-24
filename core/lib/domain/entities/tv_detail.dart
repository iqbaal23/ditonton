import 'genre.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class TvDetail extends Equatable{
  TvDetail({
    required this.backdropPath,
    required this.firstAirDate,
    required this.genres,
    required this.id,
    required this.name,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
  });

  String? backdropPath;
  String firstAirDate;
  List<Genre> genres;
  int id;
  String name;
  String overview;
  double popularity;
  String posterPath;
  double voteAverage;
  int voteCount;

  @override
  List<Object?> get props => [
    backdropPath,
    firstAirDate,
    genres,
    id,
    name,
    overview,
    popularity,
    posterPath,
    voteAverage,
    voteCount,
  ];

}