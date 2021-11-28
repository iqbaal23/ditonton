import 'package:core/presentation/bloc/popular_tvs/popular_tvs_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopularTvsPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv';

  @override
  _PopularTvsPageState createState() => _PopularTvsPageState();
}

class _PopularTvsPageState extends State<PopularTvsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<PopularTvsBloc>().add(PopularTvsHasDataEvent()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvsBloc, PopularTvsState>(
          builder: (context, state) {
            if (state is PopularTvsLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularTvsHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.results[index];
                  return TvCard(tv);
                },
                itemCount: state.results.length,
              );
            } else if (state is PopularTvsError) {
              return Text(state.message);
            } else if (state is PopularTvsEmpty) {
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
