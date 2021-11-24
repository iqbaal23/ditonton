import 'package:core/data/models/movie_table.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tMovieTabel = MovieTable(
      id: 1, title: 'title', posterPath: 'posterPath', overview: 'overview');

  test('should return a JSON map containing proper data', () async {
    // arrange

    // act
    final result = tMovieTabel.toJson();
    // assert
    final expectedJsonMap = {
      "id": 1,
      "overview": 'overview',
      "posterPath": 'posterPath',
      "title": 'title',
    };
    expect(result, expectedJsonMap);
  });
}
