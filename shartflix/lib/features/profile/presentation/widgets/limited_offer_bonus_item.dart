import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';

/// Single bonus item for the limited offer bottom sheet: icon in circle + label.
class LimitedOfferBonusItem extends StatelessWidget {
  final Widget icon;
  final String label;

  const LimitedOfferBonusItem({
    super.key,
    required this.icon,
    required this.label,
  });

  /// Premium account
  factory LimitedOfferBonusItem.premiumAccount() => LimitedOfferBonusItem(
        icon: SvgPicture.asset(
          AppAssets.images.limitedOfferPremium,
          width: 24,
          height: 24,
          fit: BoxFit.contain,
        ),
        label: 'Premium Hesap',
      );

  /// More matches
  factory LimitedOfferBonusItem.moreMatches() => LimitedOfferBonusItem(
        icon: SvgPicture.asset(
          AppAssets.images.limitedOfferMoreMatch,
          width: 24,
          height: 24,
          fit: BoxFit.contain,
        ),
        label: 'Daha Fazla Eşleşme',
      );

  /// Highlight / promotion
  factory LimitedOfferBonusItem.highlight() => LimitedOfferBonusItem(
        icon: SvgPicture.asset(
          AppAssets.images.limitedOfferHighlight,
          width: 24,
          height: 24,
          fit: BoxFit.contain,
        ),
        label: 'Öne Çıkarma',
      );

  /// More likes
  factory LimitedOfferBonusItem.moreLikes() => LimitedOfferBonusItem(
        icon: SvgPicture.asset(
          AppAssets.images.limitedOfferMoreLike,
          width: 24,
          height: 24,
          fit: BoxFit.contain,
        ),
        label: 'Daha Fazla Beğeni',
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(child: icon),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
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
