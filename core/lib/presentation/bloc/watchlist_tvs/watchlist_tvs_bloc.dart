import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/usecases/get_tv_watchlist_status.dart';
import 'package:core/domain/usecases/get_watchlist_tvs.dart';
import 'package:core/domain/usecases/remove_tv_watchlist.dart';
import 'package:core/domain/usecases/save_tv_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'watchlist_tvs_state.dart';
part 'watchlist_tvs_event.dart';

class WatchlistTvsBloc extends Bloc<WatchlistTvsEvent, WatchlistTvsState> {
  final GetWatchlistTvs _getWatchlistTvs;
  final GetTvWatchListStatus _getTvWatchListStatus;
  final SaveTvWatchlist _saveTvWatchlist;
  final RemoveTvWatchlist _removeTvWatchlist;

  WatchlistTvsBloc(this._getWatchlistTvs, this._getTvWatchListStatus,
      this._saveTvWatchlist, this._removeTvWatchlist)
      : super(WatchlistTvsEmpty());

  Stream<WatchlistTvsState> mapEventToState(
    WatchlistTvsEvent event,
  ) async* {
    if (event is WatchlistTvsHasDataEvent) {
      yield WatchlistTvsLoading();
      final result = await _getWatchlistTvs.execute();

      yield* result.fold(
        (failure) async* {
          yield WatchlistTvsError(failure.message);
        },
        (data) async* {
          if (data.isEmpty) {
            yield WatchlistTvsEmpty();
          } else {
            yield WatchlistTvsHasData(data);
          }
        },
      );
    } else if (event is SaveWatchListTvsEvent) {
      final result = await _saveTvWatchlist.execute(event.tvDetail);

      yield* result.fold(
        (failure) async* {
          yield WatchlistTvsError(failure.message);
        },
        (data) async* {
          yield SaveWatchlistTvs(true);
          yield WatchlistTvsStatus(true);
        },
      );
    } else if (event is RemoveWatchListTvsEvent) {
      final result = await _removeTvWatchlist.execute(event.tvDetail);

      yield* result.fold(
        (failure) async* {
          yield WatchlistTvsError(failure.message);
        },
        (data) async* {
          yield RemoveWatchlistTvs(true);
          yield WatchlistTvsStatus(false);
        },
      );
    } else if (event is WatchlistTvsStatusEvent) {
      final id = event.id;
      final result = await _getTvWatchListStatus.execute(id);

      yield WatchlistTvsStatus(result);
    }
  }
}
