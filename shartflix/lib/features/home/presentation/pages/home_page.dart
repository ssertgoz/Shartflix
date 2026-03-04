import 'dart:async';

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
    if (index >= state.movies.length - 2 &&
        !state.hasReachedMax &&
        state.status != HomeStatus.loadingMore) {
      context.read<HomeBloc>().add(FetchMovies(page: state.currentPage + 1));
    }
  }

  Future<void> _onRefresh() async {
    final bloc = context.read<HomeBloc>();
    final completer = Completer<void>();
    late StreamSubscription<HomeState> sub;
    sub = bloc.stream.listen((state) {
      if (state.status == HomeStatus.success || state.status == HomeStatus.failure) {
        if (!completer.isCompleted) completer.complete();
        sub.cancel();
      }
    });
    bloc.add(const RefreshMovies());
    await completer.future;
    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
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

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppColors.primary,
                backgroundColor: AppColors.surfaceElevated,
                displacement: 60,
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemCount: state.movies.length,
                  onPageChanged: (index) => _onPageChanged(index, state),
                  itemBuilder: (context, index) {
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
                ),
              ),
              // Background paging indicator — visible while next page loads
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: state.status == HomeStatus.loadingMore
                    ? const Positioned(
                        key: ValueKey('paging-loader'),
                        bottom: 96,
                        left: 0,
                        right: 0,
                        child: _PagingLoader(),
                      )
                    : const SizedBox.shrink(key: ValueKey('paging-hidden')),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Floating pill shown at the bottom while loading the next page in background.
class _PagingLoader extends StatelessWidget {
  const _PagingLoader();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.black.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.white20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 1.5,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              l10n.loadingMovies,
              style: const TextStyle(
                color: AppColors.white80,
                fontSize: 12,
                fontFamily: 'InstrumentSans',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
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
              decoration: const BoxDecoration(
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
              AppLocalizations.of(context).connectionError,
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
