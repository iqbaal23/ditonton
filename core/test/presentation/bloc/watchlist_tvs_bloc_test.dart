import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_tv_watchlist_status.dart';
import 'package:core/domain/usecases/get_watchlist_tvs.dart';
import 'package:core/domain/usecases/remove_tv_watchlist.dart';
import 'package:core/domain/usecases/save_tv_watchlist.dart';
import 'package:core/presentation/bloc/watchlist_tvs/watchlist_tvs_bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tvs_page_test.mocks.dart';

@GenerateMocks(
    [GetWatchlistTvs, GetTvWatchListStatus, SaveTvWatchlist, RemoveTvWatchlist])
void main() {
  late WatchlistTvsBloc watchlistTvsBloc;
  late MockGetWatchlistTvs mockGetWatchlistTvs;
  late MockGetTvWatchListStatus mockGetTvWatchListStatus;
  late MockSaveTvWatchlist mockSaveTvWatchlist;
  late MockRemoveTvWatchlist mockRemoveTvWatchlist;

  setUp(() {
    mockGetWatchlistTvs = MockGetWatchlistTvs();
    mockGetTvWatchListStatus = MockGetTvWatchListStatus();
    mockSaveTvWatchlist = MockSaveTvWatchlist();
    mockRemoveTvWatchlist = MockRemoveTvWatchlist();
    watchlistTvsBloc = WatchlistTvsBloc(
        mockGetWatchlistTvs,
        mockGetTvWatchListStatus,
        mockSaveTvWatchlist,
        mockRemoveTvWatchlist);
  });

  test('initial state should be empty', () {
    expect(watchlistTvsBloc.state, WatchlistTvsEmpty());
  });

  blocTest<WatchlistTvsBloc, WatchlistTvsState>(
      'Shlould emit [Loading, HasData] when watchlist Tv data is gotten successfully',
      build: () {
        when(mockGetWatchlistTvs.execute())
            .thenAnswer((_) async => Right(testTvList));
        return watchlistTvsBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvsHasDataEvent()),
      expect: () => [
            WatchlistTvsLoading(),
            WatchlistTvsHasData(testTvList),
          ],
      verify: (bloc) {
        verify(mockGetWatchlistTvs.execute());
      });

  blocTest<WatchlistTvsBloc, WatchlistTvsState>(
      'Shlould emit [Loading, Error] when watchlist Tv data is unsuccessful',
      build: () {
        when(mockGetWatchlistTvs.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return watchlistTvsBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvsHasDataEvent()),
      expect: () => [
            WatchlistTvsLoading(),
            WatchlistTvsError('Server Failure'),
          ],
      verify: (bloc) {
        verify(mockGetWatchlistTvs.execute());
      });
}
