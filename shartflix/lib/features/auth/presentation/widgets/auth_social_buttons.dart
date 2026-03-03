import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';

/// Row of Google, Apple, and Facebook social login buttons.
class AuthSocialButtons extends StatelessWidget {
  final VoidCallback? onGoogleTap;
  final VoidCallback? onAppleTap;
  final VoidCallback? onFacebookTap;

  const AuthSocialButtons({
    super.key,
    this.onGoogleTap,
    this.onAppleTap,
    this.onFacebookTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _AuthSocialButton(
          svgPath: AppAssets.icons.google,
          onTap: onGoogleTap ?? () {},
        ),
        const SizedBox(width: 16),
        _AuthSocialButton(
          svgPath: AppAssets.icons.apple,
          onTap: onAppleTap ?? () {},
        ),
        const SizedBox(width: 16),
        _AuthSocialButton(
          svgPath: AppAssets.icons.facebook,
          onTap: onFacebookTap ?? () {},
        ),
      ],
    );
  }
}

class _AuthSocialButton extends StatelessWidget {
  final String svgPath;
  final VoidCallback onTap;

  const _AuthSocialButton({
    required this.svgPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 60,
        height: 60,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          border: Border.all(color: AppColors.inputBorder),
          borderRadius: BorderRadius.circular(16),
        ),
        child: SvgPicture.asset(
          svgPath,
          width: 24,
          height: 24,
        ),
      ),
    );
  }
}
