part of 'watchlist_movies_bloc.dart';

abstract class WatchlistMoviesState extends Equatable {
  const WatchlistMoviesState();

  @override
  List<Object> get props => [];
}

class WatchlistMoviesEmpty extends WatchlistMoviesState {}

class WatchlistMoviesLoading extends WatchlistMoviesState {}

class WatchlistMoviesError extends WatchlistMoviesState{
  final String message;

  WatchlistMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistMoviesHasData extends WatchlistMoviesState{
  final List<Movie> results;

  WatchlistMoviesHasData(this.results);

  @override
  List<Object> get props => [results];
}

class SaveWatchlistMoives extends WatchlistMoviesState{
  final bool status;

  SaveWatchlistMoives(this.status);

  @override
  List<Object> get props => [status];
}

class RemoveWatchlistMoives extends WatchlistMoviesState{
  final bool status;

  RemoveWatchlistMoives(this.status);

  @override
  List<Object> get props => [status];
}

// ignore: must_be_immutable
class WatchlistMoivesStatus extends WatchlistMoviesState{
  bool status = false;

  WatchlistMoivesStatus(this.status);

  @override
  List<Object> get props => [status];
}