import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/usecases/get_tv_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_detail_state.dart';
part 'tv_detail_event.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail _getTvDetail;

  TvDetailBloc(this._getTvDetail)
      : super(TvDetailEmpty());

  Stream<TvDetailState> mapEventToState(
    TvDetailEvent event,
  ) async* {
    if (event is TvDetailHasDataEvent){
      yield TvDetailLoading();
      final result = await _getTvDetail.execute(event.id);

      yield* result.fold(
        (failure) async* {
          yield TvDetailError(failure.message);
        },
        (data) async* {
          yield TvDetailHasData(data);
        },
      );
    }
  }
}
