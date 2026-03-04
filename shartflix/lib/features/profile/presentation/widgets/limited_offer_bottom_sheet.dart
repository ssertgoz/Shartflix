import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/auth_background.dart';
import '../../../../core/widgets/close_button_circle.dart';
import '../../../auth/presentation/widgets/auth_button.dart';
import 'limited_offer_bonus_item.dart';
import 'limited_offer_token_card.dart';
import 'package:shartflix/l10n/app_localizations.dart';

void showLimitedOfferBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
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
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      clipBehavior: Clip.antiAlias,
      child: AuthBackground(
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 32,
              top: 8,
              left: 20,
              right: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHandleAndClose(context),
                  const SizedBox(height: 16),
                  _buildHeader(context, l10n),
                  const SizedBox(height: 24),
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHandleAndClose(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: CloseButtonCircle(
              onPressed: () => Navigator.pop(context),
              size: 40,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
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
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            l10n.limitedOfferSubtitle,
            style: const TextStyle(
              color: AppColors.textSecondary,
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
        color: AppColors.surfaceElevated.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.bonusesYouGet,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: 'InstrumentSans',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              LimitedOfferBonusItem.premiumAccount(),
              LimitedOfferBonusItem.moreMatches(),
              LimitedOfferBonusItem.highlight(),
              LimitedOfferBonusItem.moreLikes(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTokenSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.selectTokenPackageToUnlock,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'InstrumentSans',
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: LimitedOfferTokenCard(
                badgeText: '+10%',
                badgeColor: AppColors.primaryDark,
                oldAmount: '200',
                newAmount: '300',
                price: '₺99,99',
                isHighlighted: false,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: LimitedOfferTokenCard(
                badgeText: '+70%',
                badgeColor: const Color(0xFF3D2B99),
                oldAmount: '2.000',
                newAmount: '3.375',
                price: '₺799,99',
                isHighlighted: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: LimitedOfferTokenCard(
                badgeText: '+35%',
                badgeColor: AppColors.primaryDark,
                oldAmount: '1.000',
                newAmount: '1.350',
                price: '₺399,99',
                isHighlighted: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
