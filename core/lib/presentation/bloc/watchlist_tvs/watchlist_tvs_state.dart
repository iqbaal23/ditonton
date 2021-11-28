part of 'watchlist_tvs_bloc.dart';

abstract class WatchlistTvsState extends Equatable {
  const WatchlistTvsState();

  @override
  List<Object> get props => [];
}

class WatchlistTvsEmpty extends WatchlistTvsState {}

class WatchlistTvsLoading extends WatchlistTvsState {}

class WatchlistTvsError extends WatchlistTvsState{
  final String message;

  WatchlistTvsError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistTvsHasData extends WatchlistTvsState{
  final List<Tv> results;

  WatchlistTvsHasData(this.results);

  @override
  List<Object> get props => [results];
}

class SaveWatchlistTvs extends WatchlistTvsState{
  final bool status;

  SaveWatchlistTvs(this.status);

  @override
  List<Object> get props => [status];
}

class RemoveWatchlistTvs extends WatchlistTvsState{
  final bool status;

  RemoveWatchlistTvs(this.status);

  @override
  List<Object> get props => [status];
}

// ignore: must_be_immutable
class WatchlistTvsStatus extends WatchlistTvsState{
  bool status = false;

  WatchlistTvsStatus(this.status);

  @override
  List<Object> get props => [status];
}