import 'package:core/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<PopularMoviesBloc>().add(PopularMoviesHasDataEvent()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
          builder: (context, state) {
            if (state is PopularMoviesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularMoviesHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.results[index];
                  return MovieCard(movie);
                },
                itemCount: state.results.length,
              );
            } else if (state is PopularMoviesError) {
              return Text(state.message);
            } else if (state is PopularMoviesEmpty) {
              return Text('Empty Data');
            } else {
              return Center(
                key: Key('error_message'),
                child: Text('There is something wrong'),
              );
            }
          },
        ),
      ),
    );
  }
}
