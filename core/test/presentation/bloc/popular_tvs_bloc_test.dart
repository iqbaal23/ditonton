import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_popular_tvs.dart';
import 'package:core/presentation/bloc/popular_tvs/popular_tvs_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'popular_tvs_page_test.mocks.dart';


@GenerateMocks([GetPopularTvs])
void main() {
  late PopularTvsBloc popularTvsBloc;
  late MockGetPopularTvs mockGetPopularTvs;

  setUp(() {
    mockGetPopularTvs = MockGetPopularTvs();
    popularTvsBloc = PopularTvsBloc(mockGetPopularTvs);
  });

  
  test('initial state should be empty', () {
    expect(popularTvsBloc.state, PopularTvsEmpty());
  });

  blocTest<PopularTvsBloc, PopularTvsState>(
    'Shlould emit [Loading, HasData] when popular Tv data is gotten successfully',
    build: () {
      when(mockGetPopularTvs.execute())
        .thenAnswer((_) async => Right(testTvList));
      return popularTvsBloc;
    },
    act: (bloc) => bloc.add(PopularTvsHasDataEvent()),
    expect: () => [
      PopularTvsLoading(),
      PopularTvsHasData(testTvList),
    ],
    verify: (bloc) {
      verify(mockGetPopularTvs.execute());
    }
  );

  blocTest<PopularTvsBloc, PopularTvsState>(
    'Shlould emit [Loading, Error] when popular Tv data is unsuccessful',
    build: () {
      when(mockGetPopularTvs.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularTvsBloc;
    },
    act: (bloc) => bloc.add(PopularTvsHasDataEvent()),
    expect: () => [
      PopularTvsLoading(),
      PopularTvsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetPopularTvs.execute());
    }
  );
}
