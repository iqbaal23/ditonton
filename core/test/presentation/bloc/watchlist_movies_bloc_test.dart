import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_movie_watchlist_status.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:core/domain/usecases/remove_movie_watchlist.dart';
import 'package:core/domain/usecases/save_movie_watchlist.dart';
import 'package:core/presentation/bloc/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_movies_page_test.mocks.dart';

@GenerateMocks([
  GetWatchlistMovies,
  GetMovieWatchListStatus,
  SaveMovieWatchlist,
  RemoveMovieWatchlist
])
void main() {
  late WatchlistMoviesBloc watchlistMoviesBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetMovieWatchListStatus mockGetMovieWatchListStatus;
  late MockSaveMovieWatchlist mockSaveMovieWatchlist;
  late MockRemoveMovieWatchlist mockRemoveMovieWatchlist;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetMovieWatchListStatus = MockGetMovieWatchListStatus();
    mockSaveMovieWatchlist = MockSaveMovieWatchlist();
    mockRemoveMovieWatchlist = MockRemoveMovieWatchlist();
    watchlistMoviesBloc = WatchlistMoviesBloc(
        mockGetWatchlistMovies,
        mockGetMovieWatchListStatus,
        mockSaveMovieWatchlist,
        mockRemoveMovieWatchlist);
  });

  test('initial state should be empty', () {
    expect(watchlistMoviesBloc.state, WatchlistMoviesEmpty());
  });

  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'Shlould emit [Loading, HasData] when watchlist movie data is gotten successfully',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(WatchlistMoviesHasDataEvent()),
      expect: () => [
            WatchlistMoviesLoading(),
            WatchlistMoviesHasData(testMovieList),
          ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      });

  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'Shlould emit [Loading, Error] when watchlist movie data is unsuccessful',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(WatchlistMoviesHasDataEvent()),
    expect: () => [
      WatchlistMoviesLoading(),
      WatchlistMoviesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );
}
