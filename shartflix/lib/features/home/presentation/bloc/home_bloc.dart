import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/logger_service.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/usecases/get_movies_usecase.dart';
import '../../domain/usecases/get_favorites_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetMoviesUseCase getMovies;
  final ToggleFavoriteUseCase toggleFavorite;
  final GetFavoritesUseCase getFavorites;

  HomeBloc({
    required this.getMovies,
    required this.toggleFavorite,
    required this.getFavorites,
  }) : super(const HomeState()) {
    on<FetchMovies>(_onFetchMovies);
    on<RefreshMovies>(_onRefreshMovies);
    on<ToggleFavoriteMovie>(_onToggleFavorite);
  }

  Future<void> _onFetchMovies(
    FetchMovies event,
    Emitter<HomeState> emit,
  ) async {
    if (state.hasReachedMax && event.page > 1) return;
    if (state.status == HomeStatus.loadingMore) return;

    if (event.page == 1) {
      emit(state.copyWith(status: HomeStatus.loading));
    } else {
      emit(state.copyWith(status: HomeStatus.loadingMore));
    }

    final result = await getMovies(event.page);

    result.fold(
      (failure) {
        logger.error('Fetch movies failed: ${failure.message}');
        emit(state.copyWith(
          status: HomeStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (data) {
        final updatedMovies = event.page == 1
            ? data.movies
            : [...state.movies, ...data.movies];

        final favIds = {...state.favoriteIds};

        emit(state.copyWith(
          status: HomeStatus.success,
          movies: updatedMovies.map((m) => m.copyWith(isFavorite: favIds.contains(m.id))).toList(),
          currentPage: data.currentPage,
          totalPages: data.totalPages,
          hasReachedMax: data.currentPage >= data.totalPages,
          favoriteIds: favIds,
        ));
      },
    );
  }

  Future<void> _onRefreshMovies(
    RefreshMovies event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeState());
    add(const FetchMovies(page: 1));

    // Also refresh favorites
    final favResult = await getFavorites();
    favResult.fold(
      (_) {},
      (favorites) {
        final favIds = favorites.map((m) => m.id).toSet();
        final updatedMovies = state.movies
            .map((m) => m.copyWith(isFavorite: favIds.contains(m.id)))
            .toList();
        emit(state.copyWith(
          favoriteIds: favIds,
          movies: updatedMovies,
        ));
      },
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteMovie event,
    Emitter<HomeState> emit,
  ) async {
    // Optimistic update
    final currentFavIds = Set<String>.from(state.favoriteIds);
    final isCurrentlyFav = currentFavIds.contains(event.movieId);

    if (isCurrentlyFav) {
      currentFavIds.remove(event.movieId);
    } else {
      currentFavIds.add(event.movieId);
    }

    final updatedMovies = state.movies
        .map((m) => m.id == event.movieId
            ? m.copyWith(isFavorite: !isCurrentlyFav)
            : m)
        .toList();

    emit(state.copyWith(
      movies: updatedMovies,
      favoriteIds: currentFavIds,
      isTogglingFavorite: true,
    ));

    final result = await toggleFavorite(event.movieId);

    result.fold(
      (failure) {
        logger.error('Toggle favorite failed: ${failure.message}');
        // Revert optimistic update
        final revertedFavIds = Set<String>.from(currentFavIds);
        if (isCurrentlyFav) {
          revertedFavIds.add(event.movieId);
        } else {
          revertedFavIds.remove(event.movieId);
        }
        final revertedMovies = state.movies
            .map((m) => m.id == event.movieId
                ? m.copyWith(isFavorite: isCurrentlyFav)
                : m)
            .toList();
        emit(state.copyWith(
          movies: revertedMovies,
          favoriteIds: revertedFavIds,
          isTogglingFavorite: false,
        ));
      },
      (_) {
        emit(state.copyWith(isTogglingFavorite: false));
      },
    );
  }
}
