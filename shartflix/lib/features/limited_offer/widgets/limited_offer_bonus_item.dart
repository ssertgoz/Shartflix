import 'package:flutter/material.dart';
import 'package:inner_shadow_container/inner_shadow_container.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import 'package:shartflix/l10n/app_localizations.dart';

/// Single bonus item for the limited offer bottom sheet: icon in circle + label.
class LimitedOfferBonusItem extends StatelessWidget {
  final String assetPath;
  final String label;

  const LimitedOfferBonusItem({
    super.key,
    required this.assetPath,
    required this.label,
  });

  factory LimitedOfferBonusItem.premiumAccount(AppLocalizations l10n) =>
      LimitedOfferBonusItem(
        assetPath: AppAssets.images.limitedOfferPremium,
        label: l10n.bonusPremiumAccount,
      );

  factory LimitedOfferBonusItem.moreMatches(AppLocalizations l10n) =>
      LimitedOfferBonusItem(
        assetPath: AppAssets.images.limitedOfferMoreMatch,
        label: l10n.bonusMoreMatches,
      );

  factory LimitedOfferBonusItem.highlight(AppLocalizations l10n) =>
      LimitedOfferBonusItem(
        assetPath: AppAssets.images.limitedOfferHighlight,
        label: l10n.bonusHighlight,
      );

  factory LimitedOfferBonusItem.moreLikes(AppLocalizations l10n) =>
      LimitedOfferBonusItem(
        assetPath: AppAssets.images.limitedOfferMoreLike,
        label: l10n.bonusMoreLikes,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InnerShadowContainer(
          width: 56,
          height: 56,
          borderRadius: 28,
          backgroundColor: const Color(0xFF6F060B),
          blur: 5,
          offset: Offset.zero,
          shadowColor: AppColors.white30,
          isShadowTopLeft: true,
          isShadowTopRight: true,
          isShadowBottomLeft: true,
          isShadowBottomRight: true,
          child: Center(
            child: Image.asset(
              assetPath,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            fontFamily: 'InstrumentSans',
          ),
        ),
      ],
    );
  }
}
