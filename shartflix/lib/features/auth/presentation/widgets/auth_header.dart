import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Centered title and subtitle for login and register screens.
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontFamily: 'InstrumentSans',
                ) ??
                const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'InstrumentSans',
                ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontFamily: 'InstrumentSans',
                ) ??
                const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontFamily: 'InstrumentSans',
                ),
          ),
        ],
      ),
    );
  }
}
