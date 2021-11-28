import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:core/presentation/bloc/movie_recommendation/movie_recommendation_bloc.dart';
import 'package:core/presentation/bloc/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/genre.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_detail.dart';
import '../../core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class MovieDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/movie_detail';

  final int id;
  MovieDetailPage({required this.id});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieDetailBloc>().add(MovieDetailHasDataEvent(widget.id));
      context
          .read<MovieRecommendationBloc>()
          .add(MovieRecommendationHasDataEvent(widget.id));
      context
          .read<WatchlistMoviesBloc>()
          .add(WatchlistMoviesStatusEvent(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<WatchlistMoviesBloc>().add(WatchlistMoviesHasDataEvent());
        return true;
      },
      child: Scaffold(
        body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
          builder: (context, state) {
            if (state is MovieDetailLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is MovieDetailHasData) {
              return BlocBuilder<MovieRecommendationBloc,
                      MovieRecommendationState>(
                  builder: (recommContext, recommState) {
                return BlocBuilder<WatchlistMoviesBloc, WatchlistMoviesState>(
                    builder: (watchContext, watchState) {
                  return SafeArea(
                    child: DetailContent(
                      state.results,
                      recommState is MovieRecommendationHasData
                          ? recommState.results
                          : List.empty(),
                      watchState is WatchlistMoivesStatus
                          ? watchState.status
                          : false,
                    ),
                  );
                });
              });
            } else {
              return Text('There is something wrong');
            }
          },
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class DetailContent extends StatelessWidget {
  final MovieDetail movie;
  final List<Movie> recommendations;
  bool isAddedWatchlist;

  DetailContent(this.movie, this.recommendations, this.isAddedWatchlist);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocListener<WatchlistMoviesBloc, WatchlistMoviesState>(
        listener: (context, state) {
          if (state is SaveWatchlistMoives) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Added to Watchlist'),
            ));
          } else if (state is RemoveWatchlistMoives) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Removed from Watchlist'),
            ));
          } else if (state is WatchlistMoviesError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
            ));
          }
        },
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
              width: screenWidth,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Container(
              margin: const EdgeInsets.only(top: 48 + 8),
              child: DraggableScrollableSheet(
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: kRichBlack,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    padding: const EdgeInsets.only(
                      left: 16,
                      top: 16,
                      right: 16,
                    ),
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: kHeading5,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (!isAddedWatchlist) {
                                      context
                                          .read<WatchlistMoviesBloc>()
                                          .add(SaveWatchListMoviesEvent(movie));
                                    } else {
                                      context.read<WatchlistMoviesBloc>().add(
                                          RemoveWatchListMoviesEvent(movie));
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      isAddedWatchlist
                                          ? Icon(Icons.check)
                                          : Icon(Icons.add),
                                      Text('Watchlist'),
                                    ],
                                  ),
                                ),
                                Text(
                                  _showGenres(movie.genres),
                                ),
                                Text(
                                  _showDuration(movie.runtime),
                                ),
                                Row(
                                  children: [
                                    RatingBarIndicator(
                                      rating: movie.voteAverage / 2,
                                      itemCount: 5,
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: kMikadoYellow,
                                      ),
                                      itemSize: 24,
                                    ),
                                    Text('${movie.voteAverage}')
                                  ],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Overview',
                                  style: kHeading6,
                                ),
                                Text(
                                  movie.overview,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Recommendations',
                                  style: kHeading6,
                                ),
                                BlocBuilder<MovieRecommendationBloc,
                                    MovieRecommendationState>(
                                  builder: (context, state) {
                                    if (state is MovieRecommendationLoading) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (state
                                        is MovieRecommendationError) {
                                      return Text(state.message);
                                    } else if (state
                                        is MovieRecommendationHasData) {
                                      return Container(
                                        height: 150,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            final movie =
                                                recommendations[index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator
                                                      .pushReplacementNamed(
                                                    context,
                                                    MovieDetailPage.ROUTE_NAME,
                                                    arguments: movie.id,
                                                  );
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                                    placeholder:
                                                        (context, url) =>
                                                            Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount: recommendations.length,
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            color: Colors.white,
                            height: 4,
                            width: 48,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                // initialChildSize: 0.5,
                minChildSize: 0.25,
                // maxChildSize: 1.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: kRichBlack,
                foregroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            )
          ],
        ));
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
