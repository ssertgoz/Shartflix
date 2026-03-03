import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:see_more_text/see_more_text.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/movie_entity.dart';

/// Full-screen reel item: one movie per page (Reels-style).
class MovieReelItem extends StatefulWidget {
  final MovieEntity movie;
  final VoidCallback onFavoriteToggle;

  const MovieReelItem({
    super.key,
    required this.movie,
    required this.onFavoriteToggle,
  });

  @override
  State<MovieReelItem> createState() => _MovieReelItemState();
}

class _MovieReelItemState extends State<MovieReelItem> {
  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final onFavoriteToggle = widget.onFavoriteToggle;

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: _ReelPoster(movie: movie),
        ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        AppAssets.images.launcherIcon,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          movie.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'InstrumentSans',
                            shadows: [
                              Shadow(color: Colors.black54, blurRadius: 8),
                            ],
                          ),
                        ),
                      ),
                      if (movie.description.isNotEmpty) ...[
                        SeeMoreText(
                          animationCurve: Curves.easeInOut,
                          animationDuration: const Duration(milliseconds: 300),
                          text: movie.description,
                          maxLines: 2,
                          seeMoreText: ' Devamı Oku',
                          seeLessText: ' Daha az',
                          textStyle: const TextStyle(
                            color: AppColors.white80,
                            fontSize: 14,
                            height: 1.35,
                            fontFamily: 'InstrumentSans',
                          ),
                          seeMoreLessTextStyle: const TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'InstrumentSans',
                          ),
                          enableTextTapToggle: true,
                        ),
                      ],
                    ],
                  )),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          right: 16,
          bottom: 200,
          child: GestureDetector(
            onTap: onFavoriteToggle,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(82),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  width: 52,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.black.withValues(alpha: movie.isFavorite ? 0.2 : 0.05),
                    borderRadius: BorderRadius.circular(82),
                    border: Border.all(
                        color: AppColors.white.withValues(alpha: movie.isFavorite ? 0.6 : 0.2),
                        width: 1),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      movie.isFavorite ? AppAssets.icons.heartFill : AppAssets.icons.heart,
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        movie.isFavorite ? AppColors.primary : Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
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
  Timer? _cycleTimer;

  @override
  void initState() {
    super.initState();
    _candidates = _buildCandidates();
    _urlIndex = 0;
    _startCycleTimer();
  }

  @override
  void didUpdateWidget(_ReelPoster oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.movie.id != widget.movie.id) {
      _cycleTimer?.cancel();
      _candidates = _buildCandidates();
      _urlIndex = 0;
      _startCycleTimer();
    }
  }

  @override
  void dispose() {
    _cycleTimer?.cancel();
    super.dispose();
  }

  List<String> _buildCandidates() {
    final list = <String>[];
    if (widget.movie.posterUrl.isNotEmpty) list.add(widget.movie.posterUrl);
    for (final url in widget.movie.images) {
      if (url.isNotEmpty && !list.contains(url)) list.add(url);
    }
    return list;
  }

  void _startCycleTimer() {
    if (_candidates.length <= 1) return;
    _cycleTimer?.cancel();
    _cycleTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
      setState(() {
        _urlIndex = (_urlIndex + 1) % _candidates.length;
      });
    });
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
    return SizedBox.expand(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        child: CachedNetworkImage(
          key: ValueKey('${widget.movie.id}_$_urlIndex'),
          imageUrl: _candidates[_urlIndex],
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          placeholder: (_, __) => Container(
            width: double.infinity,
            height: double.infinity,
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
              width: double.infinity,
              height: double.infinity,
              color: AppColors.shimmer,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
