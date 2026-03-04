import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Full-screen background with linear + radial gradient for splash, login,
/// register and profile (photo upload) screens.
class AuthBackground extends StatelessWidget {
  final Widget child;
  final bool showBottomGradient;

  const AuthBackground({
    super.key,
    required this.child,
    this.showBottomGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.authBackgroundLinear,
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.authBackgroundRadial,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: showBottomGradient ? AppColors.authBackgroundBottomRadial : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
