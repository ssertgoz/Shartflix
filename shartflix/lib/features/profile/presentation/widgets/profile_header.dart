import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/entities/user_entity.dart';
import 'package:shartflix/l10n/app_localizations.dart';

class ProfileHeader extends StatelessWidget {
  final UserEntity? user;
  final bool isUploadingPhoto;
  final VoidCallback onPickPhoto;
  final AppLocalizations l10n;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.isUploadingPhoto,
    required this.onPickPhoto,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.white5, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onPickPhoto,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                _ProfileAvatar(photoUrl: user?.photoUrl),
                if (isUploadingPhoto)
                  const Positioned.fill(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                if (user?.photoUrl == null)
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.transparent, width: 2),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        AppAssets.icons.plus,
                        width: 14,
                        height: 14,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user?.name ?? '',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            fontFamily: 'InstrumentSans',
                          ) ??
                      const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'InstrumentSans',
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: ${user?.id ?? ''}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontFamily: 'InstrumentSans',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPickPhoto,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.white5,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  l10n.uploadPhoto,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'InstrumentSans',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String? photoUrl;

  const _ProfileAvatar({this.photoUrl});

  static const double size = 56.0;

  @override
  Widget build(BuildContext context) {
    Widget avatar;
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      avatar = ClipOval(
        child: CachedNetworkImage(
          imageUrl: photoUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (_, __) => _AvatarPlaceholder(size: size),
          errorWidget: (_, __, ___) => _AvatarPlaceholder(size: size),
        ),
      );
    } else {
      avatar = _AvatarPlaceholder(size: size);
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      child: avatar,
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  final double size;

  const _AvatarPlaceholder({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE50914), Color(0xFF940309)],
        ),
      ),
      child: Center(
        child: SvgPicture.asset(
          AppAssets.icons.profile,
          width: size * 0.5,
          height: size * 0.5,
          colorFilter: const ColorFilter.mode(
            Colors.white70,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
