part of 'popular_tvs_bloc.dart';

abstract class PopularTvsState extends Equatable {
  const PopularTvsState();

  @override
  List<Object> get props => [];
}

class PopularTvsEmpty extends PopularTvsState {}

class PopularTvsLoading extends PopularTvsState {}

class PopularTvsError extends PopularTvsState{
  final String message;

  PopularTvsError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularTvsHasData extends PopularTvsState{
  final List<Tv> results;

  PopularTvsHasData(this.results);

  @override
  List<Object> get props => [results];
}