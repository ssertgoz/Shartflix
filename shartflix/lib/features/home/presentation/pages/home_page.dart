import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../bloc/home_bloc.dart';
import '../widgets/movie_reel_item.dart';
import 'package:shartflix/l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(const FetchMovies(page: 1)),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index, HomeState state) {
    final bloc = context.read<HomeBloc>();
    if (index >= state.movies.length - 2 &&
        !state.hasReachedMax &&
        state.status != HomeStatus.loadingMore) {
      bloc.add(FetchMovies(page: state.currentPage + 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state.status == HomeStatus.failure && state.movies.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? l10n.unknownError),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        buildWhen: (prev, curr) =>
            prev.movies.length != curr.movies.length ||
            prev.status != curr.status ||
            prev.favoriteIds != curr.favoriteIds,
        builder: (context, state) {
          if (state.status == HomeStatus.initial || state.status == HomeStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
            );
          }

          if (state.status == HomeStatus.failure && state.movies.isEmpty) {
            return _ErrorView(
              message: state.errorMessage ?? l10n.unknownError,
              onRetry: () => context.read<HomeBloc>().add(const FetchMovies(page: 1)),
            );
          }

          final movieCount = state.movies.length;
          final showLoader = !state.hasReachedMax && state.status == HomeStatus.loadingMore;
          final itemCount = movieCount + (showLoader ? 1 : 0);

          return PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: itemCount,
            onPageChanged: (index) => _onPageChanged(index, state),
            itemBuilder: (context, index) {
              if (index >= movieCount) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2,
                  ),
                );
              }
              final movie = state.movies[index];
              return SizedBox.expand(
                child: MovieReelItem(
                  key: ValueKey(movie.id),
                  movie: movie,
                  onFavoriteToggle: () {
                    context.read<HomeBloc>().add(ToggleFavoriteMovie(movie.id));
                    context.read<ProfileBloc>().add(const FetchProfile());
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 36,
                color: AppColors.textHint,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Bağlantı hatası',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 160,
              child: ElevatedButton(
                onPressed: onRetry,
                child: Text(AppLocalizations.of(context).tryAgain),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
