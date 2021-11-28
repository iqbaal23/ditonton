import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'popular_movies_state.dart';
part 'popular_movies_event.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies _getPopularMovies;

  PopularMoviesBloc(this._getPopularMovies)
      : super(PopularMoviesEmpty());

  Stream<PopularMoviesState> mapEventToState(
    PopularMoviesEvent event,
  ) async* {
    if (event is PopularMoviesHasDataEvent){
      yield PopularMoviesLoading();
      final result = await _getPopularMovies.execute();

      yield* result.fold(
        (failure) async* {
          yield PopularMoviesError(failure.message);
        },
        (data) async* {
          yield PopularMoviesHasData(data);
        },
      );
    }
  }
}
