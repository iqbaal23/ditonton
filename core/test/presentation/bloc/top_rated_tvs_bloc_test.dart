import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_top_rated_tvs.dart';
import 'package:core/presentation/bloc/top_rated_tvs/top_rated_tvs_bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'top_rated_tvs_page_test.mocks.dart';


@GenerateMocks([GetTopRatedTvs])
void main() {
  late TopRatedTvsBloc topRatedTvsBloc;
  late MockGetTopRatedTvs mockGetTopRatedTvs;

  setUp(() {
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    topRatedTvsBloc = TopRatedTvsBloc(mockGetTopRatedTvs);
  });

  
  test('initial state should be empty', () {
    expect(topRatedTvsBloc.state, TopRatedTvsEmpty());
  });

  blocTest<TopRatedTvsBloc, TopRatedTvsState>(
    'Shlould emit [Loading, HasData] when top rated tv data is gotten successfully',
    build: () {
      when(mockGetTopRatedTvs.execute())
        .thenAnswer((_) async => Right(testTvList));
      return topRatedTvsBloc;
    },
    act: (bloc) => bloc.add(TopRatedTvsHasDataEvent()),
    expect: () => [
      TopRatedTvsLoading(),
      TopRatedTvsHasData(testTvList),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTvs.execute());
    }
  );

  blocTest<TopRatedTvsBloc, TopRatedTvsState>(
    'Shlould emit [Loading, Error] when top rated tv data is unsuccessful',
    build: () {
      when(mockGetTopRatedTvs.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedTvsBloc;
    },
    act: (bloc) => bloc.add(TopRatedTvsHasDataEvent()),
    expect: () => [
      TopRatedTvsLoading(),
      TopRatedTvsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTvs.execute());
    }
  );
}
