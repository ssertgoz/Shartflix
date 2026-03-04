import 'package:flutter/material.dart';
import 'package:inner_shadow_container/inner_shadow_container.dart';
import '../../../../core/theme/app_colors.dart';

/// Token package card for the limited offer bottom sheet.
class LimitedOfferTokenCard extends StatelessWidget {
  final String badgeText;
  final Color badgeColor;
  final String oldAmount;
  final String newAmount;
  final String price;
  final bool isHighlighted;

  const LimitedOfferTokenCard({
    super.key,
    required this.badgeText,
    required this.badgeColor,
    required this.oldAmount,
    required this.newAmount,
    required this.price,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: isHighlighted
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF5949E6), Color(0xFF3D2B99)],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primaryDark, AppColors.primary],
              ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: (isHighlighted ? const Color(0xFF5949E6) : AppColors.primary)
                .withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: InnerShadowContainer(
          borderRadius: 12,
          backgroundColor: Colors.transparent,
          blur: 6,
          offset: const Offset(2, 2),
          shadowColor: Colors.black38,
          isShadowTopLeft: true,
          isShadowBottomRight: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DiscountBadge(
                  badgeText: badgeText,
                  badgeColor: badgeColor,
                ),
                const SizedBox(height: 10),
                if (oldAmount.isNotEmpty)
                  Text(
                    oldAmount,
                    style: TextStyle(
                      color: AppColors.white60,
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                      fontFamily: 'InstrumentSans',
                    ),
                  ),
                Text(
                  newAmount,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'InstrumentSans',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Jeton',
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontFamily: 'InstrumentSans',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'InstrumentSans',
                  ),
                ),
                Text(
                  'Başına haftalık',
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.8),
                    fontSize: 11,
                    fontFamily: 'InstrumentSans',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Discount badge (+10%, +70%, etc.) with inner shadow.
class _DiscountBadge extends StatelessWidget {
  final String badgeText;
  final Color badgeColor;

  const _DiscountBadge({
    required this.badgeText,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return InnerShadowContainer(
      borderRadius: 4,
      backgroundColor: badgeColor,
      blur: 3,
      offset: const Offset(1, 1),
      shadowColor: Colors.black38,
      isShadowTopLeft: true,
      isShadowBottomRight: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Text(
          badgeText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            fontFamily: 'InstrumentSans',
          ),
        ),
      ),
    );
  }
}
