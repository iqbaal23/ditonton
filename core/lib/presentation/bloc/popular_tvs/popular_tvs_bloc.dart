import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_popular_tvs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'popular_tvs_state.dart';
part 'popular_tvs_event.dart';

class PopularTvsBloc extends Bloc<PopularTvsEvent, PopularTvsState> {
  final GetPopularTvs _getPopularTvs;

  PopularTvsBloc(this._getPopularTvs)
      : super(PopularTvsEmpty());

  Stream<PopularTvsState> mapEventToState(
    PopularTvsEvent event,
  ) async* {
    if (event is PopularTvsHasDataEvent){
      yield PopularTvsLoading();
      final result = await _getPopularTvs.execute();

      yield* result.fold(
        (failure) async* {
          yield PopularTvsError(failure.message);
        },
        (data) async* {
          yield PopularTvsHasData(data);
        },
      );
    }
  }
}
