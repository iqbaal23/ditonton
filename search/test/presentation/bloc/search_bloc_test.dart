import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/bloc/search_movie_bloc.dart';
import 'package:search/bloc/search_tv_bloc.dart' as tv;
import 'package:search/domain/usecases/search_movies.dart';
import 'package:search/domain/usecases/search_tvs.dart';

import 'search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies, SearchTvs])
void main() {
  late SearchMovieBloc searchMovieBloc;
  late MockSearchMovies mockSearchMovies;
  late tv.SearchTvBloc searchTvBloc;
  late MockSearchTvs mockSearchTvs;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    searchMovieBloc = SearchMovieBloc(mockSearchMovies);
    mockSearchTvs = MockSearchTvs();
    searchTvBloc = tv.SearchTvBloc(mockSearchTvs);
  });

  test('initial movie state should be empty', () {
    expect(searchMovieBloc.state, SearchEmpty());
  });

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];
  final tQuery = 'spiderman';

  blocTest<SearchMovieBloc, SearchMovieState>(
    'Should emit [Loading, HasData] when movie data is gottten succesfully',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      return searchMovieBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchLoading(),
      SearchHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockSearchMovies.execute(tQuery));
    },
  );

  blocTest<SearchMovieBloc, SearchMovieState>(
    'Should emit [Loading, Error] when get movie search is unsuccessful',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return searchMovieBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchLoading(),
      SearchError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchMovies.execute(tQuery));
    },
  );

  // tv

  test('initial Tv state should be empty', () {
    expect(searchTvBloc.state, tv.SearchEmpty());
  });

    final tTvModel = Tv(
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    firstAirDate: '2002-05-01',
    name: 'Spider-Man',
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tTvList = <Tv>[tTvModel];
  final tvQuery = 'spiderman';

  blocTest<tv.SearchTvBloc, tv.SearchTvState>(
    'Should emit [Loading, HasData] when Tv data is gottten succesfully',
    build: () {
      when(mockSearchTvs.execute(tvQuery))
          .thenAnswer((_) async => Right(tTvList));
      return searchTvBloc;
    },
    act: (bloc) => bloc.add(tv.OnQueryChanged(tvQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      tv.SearchLoading(),
      tv.SearchHasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockSearchTvs.execute(tvQuery));
    },
  );

  blocTest<tv.SearchTvBloc, tv.SearchTvState>(
    'Should emit [Loading, Error] when get Tv search is unsuccessful',
    build: () {
      when(mockSearchTvs.execute(tvQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return searchTvBloc;
    },
    act: (bloc) => bloc.add(tv.OnQueryChanged(tvQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      tv.SearchLoading(),
      tv.SearchError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchTvs.execute(tvQuery));
    },
  );
}
