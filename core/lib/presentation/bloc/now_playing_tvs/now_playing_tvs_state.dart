part of 'now_playing_tvs_bloc.dart';

abstract class NowPlayingTvsState extends Equatable {
  const NowPlayingTvsState();

  @override
  List<Object> get props => [];
}

class NowPlayingTvsEmpty extends NowPlayingTvsState {}

class NowPlayingTvsLoading extends NowPlayingTvsState {}

class NowPlayingTvsError extends NowPlayingTvsState{
  final String message;

  NowPlayingTvsError(this.message);

  @override
  List<Object> get props => [message];
}

class NowPlayingTvsHasData extends NowPlayingTvsState{
  final List<Tv> results;

  NowPlayingTvsHasData(this.results);

  @override
  List<Object> get props => [results];
}