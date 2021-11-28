part of 'movie_recommendation_bloc.dart';

abstract class MovieRecommendationEvent extends Equatable {
  const MovieRecommendationEvent();

  @override
  List<Object> get props => [];
}

class MovieRecommendationHasDataEvent extends MovieRecommendationEvent {
  final int id;

  MovieRecommendationHasDataEvent(this.id);

  List<Object> get props => [id];
}