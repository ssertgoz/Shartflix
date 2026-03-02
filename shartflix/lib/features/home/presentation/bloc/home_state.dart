part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, failure, loadingMore }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<MovieEntity> movies;
  final int currentPage;
  final int totalPages;
  final bool hasReachedMax;
  final String? errorMessage;
  final Set<String> favoriteIds;
  final bool isTogglingFavorite;

  const HomeState({
    this.status = HomeStatus.initial,
    this.movies = const [],
    this.currentPage = 0,
    this.totalPages = 1,
    this.hasReachedMax = false,
    this.errorMessage,
    this.favoriteIds = const {},
    this.isTogglingFavorite = false,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<MovieEntity>? movies,
    int? currentPage,
    int? totalPages,
    bool? hasReachedMax,
    String? errorMessage,
    Set<String>? favoriteIds,
    bool? isTogglingFavorite,
  }) {
    return HomeState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isTogglingFavorite: isTogglingFavorite ?? this.isTogglingFavorite,
    );
  }

  @override
  List<Object?> get props => [
        status,
        movies,
        currentPage,
        totalPages,
        hasReachedMax,
        errorMessage,
        favoriteIds,
        isTogglingFavorite,
      ];
}
