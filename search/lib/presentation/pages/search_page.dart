import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/presentation/bloc/search_movie_bloc.dart';
import 'package:search/presentation/bloc/search_tv_bloc.dart' as tv;
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Search'),
          bottom: const TabBar(
                tabs: [
                  Tab(text: 'Movie', ),
                  Tab(text: 'Tv Series',),
                ],
                labelStyle: TextStyle(fontSize: 20),
              ),
        ),
        body: const TabBarView(children: [
          SearchMoviePage(),
          SearchTvPage(),
        ]),
      ),
    );
  }
}

class SearchMoviePage extends StatelessWidget {
  const SearchMoviePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: (query) {
              context.read<SearchMovieBloc>().add(OnQueryChanged(query));
            },
            decoration: InputDecoration(
              hintText: 'Search Movie',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.search,
          ),
          SizedBox(height: 16),
          Text(
            'Search Result',
            style: kHeading6,
          ),
          BlocBuilder<SearchMovieBloc, SearchMovieState>(
            builder: (context, state) {
              if (state is SearchLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is SearchHasData) {
                final result = state.results;
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final movie = result[index];
                      return MovieCard(movie);
                    },
                    itemCount: result.length,
                  ),
                );
              } else if (state is SearchError) {
                return Expanded(
                  child: Center(
                    child: Text(state.message),
                  ),
                );
              } else {
                return Expanded(
                  child: Container(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class SearchTvPage extends StatelessWidget {
  const SearchTvPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: (query) {
              context.read<tv.SearchTvBloc>().add(tv.OnQueryChanged(query));
            },
            decoration: InputDecoration(
              hintText: 'Search Tv Series',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.search,
          ),
          SizedBox(height: 16),
          Text(
            'Search Result',
            style: kHeading6,
          ),
          BlocBuilder<tv.SearchTvBloc, tv.SearchTvState>(
            builder: (context, state) {
              if (state is tv.SearchLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is tv.SearchHasData) {
                final result = state.results;
                print(result);
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final tv = result[index];
                      return TvCard(tv);
                    },
                    itemCount: result.length,
                  ),
                );
              } else {
                return Expanded(
                  child: Container(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
