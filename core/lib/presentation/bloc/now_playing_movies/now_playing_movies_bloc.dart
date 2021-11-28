import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'now_playing_movies_state.dart';
part 'now_playing_movies_event.dart';

class NowPlayingMoviesBloc extends Bloc<NowPlayingMoviesEvent, NowPlayingMoviesState> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  NowPlayingMoviesBloc(this._getNowPlayingMovies)
      : super(NowPlayingMoviesEmpty());

  Stream<NowPlayingMoviesState> mapEventToState(
    NowPlayingMoviesEvent event,
  ) async* {
    if (event is NowPlayingMoviesHasDataEvent){
      yield NowPlayingMoviesLoading();
      final result = await _getNowPlayingMovies.execute();

      yield* result.fold(
        (failure) async* {
          yield NowPlayingMoviesError(failure.message);
        },
        (data) async* {
          yield NowPlayingMoviesHasData(data);
        },
      );
    }
  }
}
