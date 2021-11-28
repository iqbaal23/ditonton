part of 'movie_detail_bloc.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class MovieDetailHasDataEvent extends MovieDetailEvent {
  final int id;

  MovieDetailHasDataEvent(this.id);

  List<Object> get props => [id];
}