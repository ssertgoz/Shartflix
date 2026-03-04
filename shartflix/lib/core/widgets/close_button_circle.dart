import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Reusable circular close button with X icon.
/// Use for removing photo (photo upload) or closing modal (e.g. bottom sheet).
class CloseButtonCircle extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;

  const CloseButtonCircle({
    super.key,
    required this.onPressed,
    this.size = 44,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
            border: Border.all(
              color: borderColor ?? AppColors.white50,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.close,
            color: iconColor ?? AppColors.textPrimary,
            size: size * 0.55,
          ),
        ),
      ),
    );
  }
}
