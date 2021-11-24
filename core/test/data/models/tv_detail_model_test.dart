import 'package:core/data/models/genre_model.dart';
import 'package:core/data/models/tv_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvDetailRespon = TvDetailResponse(
      backdropPath: 'backdropPath',
      genres: [GenreModel(id: 1, name: 'Action')],
      homepage: 'homepage',
      id: 1,
      originalLanguage: 'en',
      originalName: 'originalName',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      firstAirDate: 'firstAirDate',
      status: 'status',
      tagline: 'tagline',
      name: 'name',
      voteAverage: 1,
      voteCount: 1);

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvDetailRespon.toJson();
      // assert
      final expectedJsonMap = {
        "backdrop_path": 'backdropPath',
        "genres": [{'id': 1, 'name': 'Action'}],
        "homepage": 'homepage',
        "id": 1,
        "original_language": 'en',
        "original_name": 'originalName',
        "overview": 'overview',
        "popularity": 1,
        "poster_path": 'posterPath',
        "first_air_date": 'firstAirDate',
        "status": 'status',
        "tagline": 'tagline',
        "name": 'name',
        "vote_average": 1,
        "vote_count": 1
      };
      expect(result, expectedJsonMap);
    });
  });
}
