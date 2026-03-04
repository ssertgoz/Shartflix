import 'package:flutter/material.dart';
import 'package:inner_shadow_container/inner_shadow_container.dart';
import '../../../../core/theme/app_colors.dart';

/// Package option card for the limited offer bottom sheet.
/// Displays a selectable token package with gradient, badge, and pricing.
class PackageOptionCard extends StatelessWidget {
  final String badgeText;
  final Color badgeColor;
  final String oldAmount;
  final String newAmount;
  final String price;
  final bool isPopular;

  const PackageOptionCard({
    super.key,
    required this.badgeText,
    required this.badgeColor,
    required this.oldAmount,
    required this.newAmount,
    required this.price,
    this.isPopular = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      children: [
        _PackageOptionCardShell(
          isPopular: isPopular,
          child: _PackageOptionTokenContent(
            oldAmount: oldAmount,
            newAmount: newAmount,
            price: price,
          ),
        ),
        _PackageOptionBadge(
          badgeText: badgeText,
          badgeColor: badgeColor,
          isPopular: isPopular,
        ),
      ],
    );
  }
}

/// Card shell: gradient layers, frosted overlay, and inner shadow.
class _PackageOptionCardShell extends StatelessWidget {
  final bool isPopular;
  final Widget child;

  const _PackageOptionCardShell({
    required this.isPopular,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Positioned.fill(
            child: _GradientLayer(isPopular: isPopular),
          ),
          Positioned.fill(
            child: _FrostedOverlay(),
          ),
          InnerShadowContainer(
            borderRadius: 12,
            backgroundColor: Colors.transparent,
            blur: 10,
            offset: Offset.zero,
            shadowColor: AppColors.white10,
            isShadowTopLeft: true,
            isShadowTopRight: true,
            isShadowBottomLeft: true,
            isShadowBottomRight: true,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 32,
                bottom: 12,
                left: 12,
                right: 12,
              ),
              child: child,
            ),
          ),
          Positioned.fill(
            child: Container(
                decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.white40,
                width: 1,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            )),
          ),
        ],
      ),
    );
  }
}

/// Base gradient layer (normal or popular).
class _GradientLayer extends StatelessWidget {
  final bool isPopular;

  const _GradientLayer({required this.isPopular});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient:
            isPopular ? AppColors.tokenCardPopularGradient : AppColors.tokenCardNormalGradient,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

/// Radial frosted glass overlay.
class _FrostedOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0.09, 0),
          radius: 1,
          colors: [
            const Color(0x1AFFFFFF), // rgba(255,255,255,0.1)
            const Color(0x07FFFFFF), // rgba(255,255,255,0.03)
          ],
          stops: const [0.0, 1.0],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

/// Token package content: amounts, Jeton label, divider, price.
class _PackageOptionTokenContent extends StatelessWidget {
  final String oldAmount;
  final String newAmount;
  final String price;

  const _PackageOptionTokenContent({
    required this.oldAmount,
    required this.newAmount,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (oldAmount.isNotEmpty)
          Text(
            oldAmount,
            style: TextStyle(
              color: AppColors.white90,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.lineThrough,
              fontFamily: 'InstrumentSans',
            ),
          ),
        Text(
          newAmount,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w700,
            height: 1.2,
            fontFamily: 'InstrumentSans',
          ),
        ),
        Text(
          'Jeton',
          style: TextStyle(
            color: AppColors.white.withValues(alpha: 0.9),
            fontSize: 14,
            fontFamily: 'InstrumentSans',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Divider(
          height: 1,
          thickness: 1,
          color: AppColors.white10,
        ),
        const SizedBox(height: 14),
        Text(
          price,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'InstrumentSans',
          ),
        ),
        Text(
          'Başına haftalık',
          style: TextStyle(
            color: AppColors.white80,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'InstrumentSans',
          ),
        ),
      ],
    );
  }
}

/// Badge overlapping the top edge of the card.
class _PackageOptionBadge extends StatelessWidget {
  final String badgeText;
  final Color badgeColor;
  final bool isPopular;

  const _PackageOptionBadge({
    required this.badgeText,
    required this.badgeColor,
    required this.isPopular,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -12,
      left: 0,
      right: 0,
      child: Center(
        child: IntrinsicWidth(
          child: InnerShadowContainer(
            height: 24,
            borderRadius: 24,
            backgroundColor: badgeColor,
            blur: 4,
            offset: const Offset(1, 1),
            shadowColor: AppColors.white50,
            isShadowTopLeft: true,
            isShadowBottomRight: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Center(
                child: Text(
                  badgeText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'InstrumentSans',
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
