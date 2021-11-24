import 'package:core/data/models/tv_table.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvTabel = TvTable(
      id: 1, name: 'name', posterPath: 'posterPath', overview: 'overview');

  test('should return a JSON map containing proper data', () async {
    // arrange

    // act
    final result = tTvTabel.toJson();
    // assert
    final expectedJsonMap = {
      "id": 1,
      "overview": 'overview',
      "posterPath": 'posterPath',
      "name": 'name',
    };
    expect(result, expectedJsonMap);
  });
}
