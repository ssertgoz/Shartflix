import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Centered prompt text with a tappable link (e.g. "Don't have an account? Sign up").
class AuthLinkPrompt extends StatelessWidget {
  final String promptText;
  final String linkText;
  final VoidCallback onLinkTap;

  const AuthLinkPrompt({
    super.key,
    required this.promptText,
    required this.linkText,
    required this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onLinkTap,
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontFamily: 'InstrumentSans',
            ),
            children: [
              TextSpan(text: promptText),
              TextSpan(
                text: linkText,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
