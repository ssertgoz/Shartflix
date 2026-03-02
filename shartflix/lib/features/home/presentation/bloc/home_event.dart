part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class FetchMovies extends HomeEvent {
  final int page;
  const FetchMovies({this.page = 1});

  @override
  List<Object> get props => [page];
}

class RefreshMovies extends HomeEvent {
  const RefreshMovies();
}

class ToggleFavoriteMovie extends HomeEvent {
  final String movieId;
  const ToggleFavoriteMovie(this.movieId);

  @override
  List<Object> get props => [movieId];
}
