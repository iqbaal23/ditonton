part of 'watchlist_movies_bloc.dart';

abstract class WatchlistMoviesEvent extends Equatable {
  const WatchlistMoviesEvent();

  @override
  List<Object> get props => [];
}

class WatchlistMoviesHasDataEvent extends WatchlistMoviesEvent {}

class SaveWatchListMoviesEvent extends WatchlistMoviesEvent {
  final MovieDetail movieDetail;

  SaveWatchListMoviesEvent(this.movieDetail);
  
  @override
  List<Object> get props => [movieDetail];
}

class RemoveWatchListMoviesEvent extends WatchlistMoviesEvent {
  final MovieDetail movieDetail;

  RemoveWatchListMoviesEvent(this.movieDetail);
  
  @override
  List<Object> get props => [movieDetail];
}

class WatchlistMoviesStatusEvent extends WatchlistMoviesEvent {
  final int id;

  WatchlistMoviesStatusEvent(this.id);

  @override
  List<Object> get props => [id];
}