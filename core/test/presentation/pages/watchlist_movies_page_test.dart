import 'package:core/utils/state_enum.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/presentation/pages/watchlist_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:core/presentation/provider/watchlist_movie_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'watchlist_movies_page_test.mocks.dart';

@GenerateMocks([WatchlistMovieNotifier])
void main() {
  late MockWatchlistMovieNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockWatchlistMovieNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<WatchlistMovieNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockNotifier.watchlistState).thenReturn(RequestState.Loading);

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display LisMovieiew when data is loaded',
      (WidgetTester tester) async {
    when(mockNotifier.watchlistState).thenReturn(RequestState.Loaded);
    when(mockNotifier.watchlistMovies).thenReturn(<Movie>[]);

    final lisMovieiewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));

    expect(lisMovieiewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockNotifier.watchlistState).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('Error message');

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
