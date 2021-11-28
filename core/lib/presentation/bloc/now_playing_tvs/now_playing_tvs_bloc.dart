import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_now_playing_tvs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'now_playing_tvs_state.dart';
part 'now_playing_tvs_event.dart';

class NowPlayingTvsBloc extends Bloc<NowPlayingTvsEvent, NowPlayingTvsState> {
  final GetNowPlayingTvs _getNowPlayingTvs;

  NowPlayingTvsBloc(this._getNowPlayingTvs)
      : super(NowPlayingTvsEmpty());

  Stream<NowPlayingTvsState> mapEventToState(
    NowPlayingTvsEvent event,
  ) async* {
    if (event is NowPlayingTvsHasDataEvent){
      yield NowPlayingTvsLoading();
      final result = await _getNowPlayingTvs.execute();

      yield* result.fold(
        (failure) async* {
          yield NowPlayingTvsError(failure.message);
        },
        (data) async* {
          yield NowPlayingTvsHasData(data);
        },
      );
    }
  }
}
