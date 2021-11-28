import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/usecases/get_movie_watchlist_status.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:core/domain/usecases/remove_movie_watchlist.dart';
import 'package:core/domain/usecases/save_movie_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'watchlist_movies_state.dart';
part 'watchlist_movies_event.dart';

class WatchlistMoviesBloc
    extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  final GetWatchlistMovies _getWatchlistMovies;
  final GetMovieWatchListStatus _getMovieWatchListStatus;
  final SaveMovieWatchlist _saveMovieWatchlist;
  final RemoveMovieWatchlist _removeMovieWatchlist;

  WatchlistMoviesBloc(this._getWatchlistMovies, this._getMovieWatchListStatus,
      this._saveMovieWatchlist, this._removeMovieWatchlist)
      : super(WatchlistMoviesEmpty());

  Stream<WatchlistMoviesState> mapEventToState(
    WatchlistMoviesEvent event,
  ) async* {
    if (event is WatchlistMoviesHasDataEvent) {
      yield WatchlistMoviesLoading();
      final result = await _getWatchlistMovies.execute();

      yield* result.fold(
        (failure) async* {
          yield WatchlistMoviesError(failure.message);
        },
        (data) async* {
          if (data.isEmpty) {
            yield WatchlistMoviesEmpty();
          } else {
            yield WatchlistMoviesHasData(data);
          }
        },
      );
    } else if (event is SaveWatchListMoviesEvent) {
      final result = await _saveMovieWatchlist.execute(event.movieDetail);

      yield* result.fold(
        (failure) async* {
          yield WatchlistMoviesError(failure.message);
        },
        (data) async* {
          yield SaveWatchlistMoives(true);
          yield WatchlistMoivesStatus(true);
        },
      );
    } else if (event is RemoveWatchListMoviesEvent) {
      final result = await _removeMovieWatchlist.execute(event.movieDetail);

      yield* result.fold(
        (failure) async* {
          yield WatchlistMoviesError(failure.message);
        },
        (data) async* {
          yield RemoveWatchlistMoives(true);
          yield WatchlistMoivesStatus(false);
        },
      );
    } else if (event is WatchlistMoviesStatusEvent) {
      final id = event.id;
      final result = await _getMovieWatchListStatus.execute(id);

      yield WatchlistMoivesStatus(result);
    }
  }
}
