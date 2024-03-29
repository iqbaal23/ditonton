part of 'search_tv_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChanged extends SearchEvent {
  final String query;
  
  OnQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}
