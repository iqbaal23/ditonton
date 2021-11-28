import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'top_rated_movies_state.dart';
part 'top_rated_movies_event.dart';

class TopRatedMoviesBloc extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  final GetTopRatedMovies _getTopRatedMovies;

  TopRatedMoviesBloc(this._getTopRatedMovies)
      : super(TopRatedMoviesEmpty());

  Stream<TopRatedMoviesState> mapEventToState(
    TopRatedMoviesEvent event,
  ) async* {
    if (event is TopRatedMoviesHasDataEvent){
      yield TopRatedMoviesLoading();
      final result = await _getTopRatedMovies.execute();

      yield* result.fold(
        (failure) async* {
          yield TopRatedMoviesError(failure.message);
        },
        (data) async* {
          yield TopRatedMoviesHasData(data);
        },
      );
    }
  }
}
