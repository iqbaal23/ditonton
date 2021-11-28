import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_top_rated_tvs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'top_rated_tvs_state.dart';
part 'top_rated_tvs_event.dart';

class TopRatedTvsBloc extends Bloc<TopRatedTvsEvent, TopRatedTvsState> {
  final GetTopRatedTvs _getTopRatedTvs;

  TopRatedTvsBloc(this._getTopRatedTvs)
      : super(TopRatedTvsEmpty());

  Stream<TopRatedTvsState> mapEventToState(
    TopRatedTvsEvent event,
  ) async* {
    if (event is TopRatedTvsHasDataEvent){
      yield TopRatedTvsLoading();
      final result = await _getTopRatedTvs.execute();

      yield* result.fold(
        (failure) async* {
          yield TopRatedTvsError(failure.message);
        },
        (data) async* {
          yield TopRatedTvsHasData(data);
        },
      );
    }
  }
}
