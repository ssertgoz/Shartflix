import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/movie_entity.dart';

/// Full-screen reel item: one movie per page (Reels-style).
class MovieReelItem extends StatelessWidget {
  final MovieEntity movie;
  final VoidCallback onFavoriteToggle;

  const MovieReelItem({
    super.key,
    required this.movie,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _ReelPoster(movie: movie),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: AppColors.reelBottomGradient,
            ),
          ),
        ),
        Positioned(
          left: 20,
          right: 80,
          bottom: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      AppAssets.images.appIcon,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'InstrumentSans',
                        shadows: [
                          Shadow(color: Colors.black54, blurRadius: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (movie.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  movie.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.35,
                    fontFamily: 'InstrumentSans',
                    shadows: [
                      Shadow(color: Colors.black45, blurRadius: 4),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Devamı Oku',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'InstrumentSans',
                  ),
                ),
              ],
            ],
          ),
        ),
        Positioned(
          right: 16,
          bottom: 250,
          child: GestureDetector(
            onTap: onFavoriteToggle,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  movie.isFavorite ? AppAssets.icons.heartFill : AppAssets.icons.heart,
                  width: 26,
                  height: 26,
                  colorFilter: ColorFilter.mode(
                    movie.isFavorite ? AppColors.primary : Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReelPoster extends StatefulWidget {
  final MovieEntity movie;

  const _ReelPoster({required this.movie});

  @override
  State<_ReelPoster> createState() => _ReelPosterState();
}

class _ReelPosterState extends State<_ReelPoster> {
  late List<String> _candidates;
  late int _urlIndex;

  @override
  void initState() {
    super.initState();
    _candidates = _buildCandidates();
    _urlIndex = 0;
  }

  @override
  void didUpdateWidget(_ReelPoster oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.movie.id != widget.movie.id) {
      _candidates = _buildCandidates();
      _urlIndex = 0;
    }
  }

  List<String> _buildCandidates() {
    final list = <String>[];
    if (widget.movie.posterUrl.isNotEmpty) list.add(widget.movie.posterUrl);
    for (final url in widget.movie.images) {
      if (url.isNotEmpty && !list.contains(url)) list.add(url);
    }
    return list;
  }

  void _tryNextUrl() {
    if (_urlIndex < _candidates.length - 1) {
      setState(() => _urlIndex++);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_candidates.isEmpty) {
      return Container(
        color: AppColors.surfaceElevated,
        child: Center(
          child: SvgPicture.asset(
            AppAssets.icons.heart,
            width: 48,
            height: 48,
            colorFilter: const ColorFilter.mode(
              AppColors.textHint,
              BlendMode.srcIn,
            ),
          ),
        ),
      );
    }
    return CachedNetworkImage(
      key: ValueKey('${widget.movie.id}_$_urlIndex'),
      imageUrl: _candidates[_urlIndex],
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        color: AppColors.shimmer,
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      ),
      errorWidget: (_, __, ___) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _tryNextUrl());
        return Container(
          color: AppColors.shimmer,
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
        );
      },
    );
  }
}
