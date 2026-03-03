import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/domain/entities/movie_entity.dart';

/// Tries posterUrl first, then cycles through movie.images on load error (same as home).
class ProfileCardPoster extends StatefulWidget {
  final MovieEntity movie;

  const ProfileCardPoster({
    super.key,
    required this.movie,
  });

  @override
  State<ProfileCardPoster> createState() => _ProfileCardPosterState();
}

class _ProfileCardPosterState extends State<ProfileCardPoster> {
  late List<String> _candidates;
  late int _urlIndex;

  @override
  void initState() {
    super.initState();
    _candidates = _buildCandidates();
    _urlIndex = 0;
  }

  @override
  void didUpdateWidget(ProfileCardPoster oldWidget) {
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
        child: const Icon(Icons.movie_outlined,
            color: AppColors.textHint, size: 40),
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
              strokeWidth: 2, color: AppColors.primary),
        ),
      ),
      errorWidget: (_, __, ___) {
        if (_urlIndex < _candidates.length - 1) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _tryNextUrl());
          return Container(
            color: AppColors.shimmer,
            child: const Center(
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: AppColors.primary),
            ),
          );
        }
        return Container(
          color: AppColors.surfaceElevated,
          child: const Icon(Icons.movie_outlined,
              color: AppColors.textHint, size: 40),
        );
      },
    );
  }
}
