import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/auth_background.dart';
import '../../../../core/widgets/close_button_circle.dart';
import '../../../auth/presentation/widgets/auth_button.dart';
import 'limited_offer_bonus_item.dart';
import 'package_option_card.dart';
import 'package:shartflix/l10n/app_localizations.dart';

void showLimitedOfferBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    barrierColor: AppColors.black.withValues(alpha: 0.8),
    backgroundColor: Colors.transparent,
    builder: (_) => const LimitedOfferBottomSheet(),
  );
}

class LimitedOfferBottomSheet extends StatelessWidget {
  const LimitedOfferBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      clipBehavior: Clip.antiAlias,
      child: AuthBackground(
        showBottomGradient: true,
        child: SafeArea(
          top: false,
          child: Padding(
              padding: EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
              ),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CloseButtonCircle(
                        onPressed: () => Navigator.pop(context),
                        size: 40,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 16),
                        _buildTitleSection(l10n),
                        const SizedBox(height: 20),
                        _buildBonusesSection(l10n),
                        const SizedBox(height: 24),
                        _buildTokenSection(l10n),
                        const SizedBox(height: 24),
                        AuthButton(
                          label: l10n.seeAllTokens,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildTitleSection(AppLocalizations l10n) {
    return Column(
      children: [
        Text(
          l10n.limitedOffer,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            fontFamily: 'InstrumentSans',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            l10n.limitedOfferSubtitle,
            style: const TextStyle(
              color: AppColors.white90,
              fontSize: 14,
              height: 1.4,
              fontFamily: 'InstrumentSans',
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildBonusesSection(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0.09, 0), // 54.56% 50%
          radius: 1,
          colors: [
            Color(0x1AFFFFFF), // rgba(255, 255, 255, 0.1)
            Color(0x07FFFFFF), // rgba(255, 255, 255, 0.03)
          ],
          stops: const [0.0, 1.0],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.white20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            l10n.bonusesYouGet,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'InstrumentSans',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: LimitedOfferBonusItem.premiumAccount()),
              Expanded(child: LimitedOfferBonusItem.moreMatches()),
              Expanded(child: LimitedOfferBonusItem.highlight()),
              Expanded(child: LimitedOfferBonusItem.moreLikes()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTokenSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          l10n.selectTokenPackageToUnlock,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'InstrumentSans',
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: PackageOptionCard(
                badgeText: '+10%',
                badgeColor: AppColors.primaryDark,
                oldAmount: '200',
                newAmount: '300',
                price: '₺99,99',
                isPopular: false,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: PackageOptionCard(
                badgeText: '+70%',
                badgeColor: const Color(0xFF5949E6),
                oldAmount: '2.000',
                newAmount: '3.375',
                price: '₺799,99',
                isPopular: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: PackageOptionCard(
                badgeText: '+35%',
                badgeColor: AppColors.primaryDark,
                oldAmount: '1.000',
                newAmount: '1.350',
                price: '₺399,99',
                isPopular: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
