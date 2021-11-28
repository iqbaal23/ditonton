import 'package:core/presentation/bloc/top_rated_tvs/top_rated_tvs_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopRatedTvsPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv';

  @override
  _TopRatedTvsPageState createState() => _TopRatedTvsPageState();
}

class _TopRatedTvsPageState extends State<TopRatedTvsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<TopRatedTvsBloc>().add(TopRatedTvsHasDataEvent()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvsBloc, TopRatedTvsState>(
          builder: (context, state) {
            if (state is TopRatedTvsLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedTvsHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.results[index];
                  return TvCard(tv);
                },
                itemCount: state.results.length,
              );
            } else if (state is TopRatedTvsError) {
              return Text(state.message);
            } else if (state is TopRatedTvsEmpty) {
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
