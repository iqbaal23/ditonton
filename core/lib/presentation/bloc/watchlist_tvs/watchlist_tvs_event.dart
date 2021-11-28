part of 'watchlist_tvs_bloc.dart';

abstract class WatchlistTvsEvent extends Equatable {
  const WatchlistTvsEvent();

  @override
  List<Object> get props => [];
}

class WatchlistTvsHasDataEvent extends WatchlistTvsEvent {}

class SaveWatchListTvsEvent extends WatchlistTvsEvent {
  final TvDetail tvDetail;

  SaveWatchListTvsEvent(this.tvDetail);
  
  @override
  List<Object> get props => [tvDetail];
}

class RemoveWatchListTvsEvent extends WatchlistTvsEvent {
  final TvDetail tvDetail;

  RemoveWatchListTvsEvent(this.tvDetail);
  
  @override
  List<Object> get props => [tvDetail];
}

class WatchlistTvsStatusEvent extends WatchlistTvsEvent {
  final int id;

  WatchlistTvsStatusEvent(this.id);

  @override
  List<Object> get props => [id];
}