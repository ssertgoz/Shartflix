import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import 'package:shartflix/l10n/app_localizations.dart';

class ProfileAppBar extends StatelessWidget {
  final AppLocalizations l10n;
  final VoidCallback onLimitedOfferTap;

  const ProfileAppBar({
    super.key,
    required this.l10n,
    required this.onLimitedOfferTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 12, top: 8, bottom: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                l10n.profile,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'InstrumentSans',
                        ) ??
                    const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'InstrumentSans',
                    ),
              ),
            ),
            GestureDetector(
              onTap: onLimitedOfferTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppAssets.icons.gem,
                      width: 18,
                      height: 18,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.limitedOffer,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'InstrumentSans',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout_rounded, color: AppColors.textSecondary, size: 22),
              onPressed: () {
                final authBloc = context.read<AuthBloc>();
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    backgroundColor: AppColors.surfaceElevated,
                    title: const Text('Çıkış Yap', style: TextStyle(color: AppColors.textPrimary)),
                    content: const Text(
                      'Hesabınızdan çıkmak istiyor musunuz?',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child:
                            const Text('İptal', style: TextStyle(color: AppColors.textSecondary)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          authBloc.add(const LogoutRequested());
                        },
                        child: Text(l10n.logout, style: const TextStyle(color: AppColors.primary)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
