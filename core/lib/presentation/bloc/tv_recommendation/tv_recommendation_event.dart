part of 'tv_recommendation_bloc.dart';

abstract class TvRecommendationEvent extends Equatable {
  const TvRecommendationEvent();

  @override
  List<Object> get props => [];
}

class TvRecommendationHasDataEvent extends TvRecommendationEvent {
  final int id;

  TvRecommendationHasDataEvent(this.id);

  List<Object> get props => [id];
}