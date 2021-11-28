import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_tv_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_recommendation_state.dart';
part 'tv_recommendation_event.dart';

class TvRecommendationBloc extends Bloc<TvRecommendationEvent, TvRecommendationState> {
  final GetTvRecommendations _getTvRecommendation;

  TvRecommendationBloc(this._getTvRecommendation)
      : super(TvRecommendationEmpty());

  Stream<TvRecommendationState> mapEventToState(
    TvRecommendationEvent event,
  ) async* {
    if (event is TvRecommendationHasDataEvent){
      yield TvRecommendationLoading();
      final result = await _getTvRecommendation.execute(event.id);

      yield* result.fold(
        (failure) async* {
          yield TvRecommendationError(failure.message);
        },
        (data) async* {
          yield TvRecommendationHasData(data);
        },
      );
    }
  }
}
