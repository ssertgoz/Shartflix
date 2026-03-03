import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/domain/entities/movie_entity.dart';
import 'favorite_movie_card.dart';
import 'package:shartflix/l10n/app_localizations.dart';

class FavoritesSection extends StatelessWidget {
  final List<MovieEntity> favorites;
  final AppLocalizations l10n;

  const FavoritesSection({
    super.key,
    required this.favorites,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Text(
              'Beğendiklerim',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'InstrumentSans',
                      ) ??
                  const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'InstrumentSans',
                  ),
            ),
          ),
          if (favorites.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  SvgPicture.asset(
                    AppAssets.icons.heart,
                    width: 48,
                    height: 48,
                    colorFilter: const ColorFilter.mode(
                      AppColors.textHint,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.noFavorites,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final movie = favorites[index];
                return FavoriteMovieCard(movie: movie);
              },
            ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
