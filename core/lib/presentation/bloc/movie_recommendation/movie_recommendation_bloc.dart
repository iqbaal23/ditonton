import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_recommendation_state.dart';
part 'movie_recommendation_event.dart';

class MovieRecommendationBloc extends Bloc<MovieRecommendationEvent, MovieRecommendationState> {
  final GetMovieRecommendations _getMovieRecommendation;

  MovieRecommendationBloc(this._getMovieRecommendation)
      : super(MovieRecommendationEmpty());

  Stream<MovieRecommendationState> mapEventToState(
    MovieRecommendationEvent event,
  ) async* {
    if (event is MovieRecommendationHasDataEvent){
      yield MovieRecommendationLoading();
      final result = await _getMovieRecommendation.execute(event.id);

      yield* result.fold(
        (failure) async* {
          yield MovieRecommendationError(failure.message);
        },
        (data) async* {
          yield MovieRecommendationHasData(data);
        },
      );
    }
  }
}
