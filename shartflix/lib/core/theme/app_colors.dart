import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // --- Brand (exact from design system) ---
  static const Color primary = Color(0xFFE50914);
  static const Color primaryDark = Color(0xFF6F060B);
  static const Color secondary = Color(0xFF5949E6);

  // --- White & Black ---
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // --- White Tones (#FFFFFF at opacity) ---
  static const Color white90 = Color(0xE6FFFFFF);
  static const Color white80 = Color(0xCCFFFFFF);
  static const Color white70 = Color(0xB3FFFFFF);
  static const Color white60 = Color(0x99FFFFFF);
  static const Color white50 = Color(0x80FFFFFF);
  static const Color white40 = Color(0x66FFFFFF);
  static const Color white30 = Color(0x4DFFFFFF);
  static const Color white20 = Color(0x33FFFFFF);
  static const Color white10 = Color(0x1AFFFFFF);
  static const Color white5 = Color(0x0DFFFFFF);

  // --- Alert & Status (exact from design system) ---
  static const Color success = Color(0xFF00C247);
  static const Color info = Color(0xFF004CE8);
  static const Color warning = Color(0xFFFFBE16);
  static const Color error = Color(0xFFF47171);

  // --- App usage (derived from black + white tones) ---
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF141414);
  static const Color surfaceElevated = Color(0xFF1C1C1C);
  static const Color card = Color(0xFF181818);
  static const Color navBackground = Color(0xFF111111);
  static const Color inputBackground = Color(0xFF1C1C1E);
  static const Color inputBorder = Color(0xFF2C2C2E);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFAAAAAA);
  static const Color textHint = Color(0xFF555555);
  static const Color textDisabled = Color(0xFF3C3C3E);
  static const Color divider = Color(0xFF2C2C2E);

  static const Color shimmer = Color(0xFF2A2A2A);
  static const Color shimmerHighlight = Color(0xFF3A3A3A);

  // --- Gradients (exact from design system) ---
  /// Bg gradient: #43FF00 → #940309
  static const LinearGradient gradientBg = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF43FF00), Color(0xFF940309)],
  );

  /// Primary / Active Nav: primary dark → primary
  static const LinearGradient gradientPrimary = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF7C060B), Color(0xFFE50914)],
  );

  /// Card overlay (transparent → black)
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x00000000), Color(0xE6000000)],
    stops: [0.3, 1.0],
  );

  /// Reel bottom overlay: 180deg, transparent in middle, dark at top (40%) and bottom (90%)
  static const LinearGradient reelBottomGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x66090909), // rgba(9,9,9,0.4) at 0%
      Color(0x00090909), // transparent at 15.38%
      Color(0x00090909), // transparent at 74.04%
      Color(0xE6090909), // rgba(9,9,9,0.9) at 89.42%
    ],
    stops: [0.0, 0.1538, 0.7404, 0.8942],
  );

  /// Splash / header (dark red → black)
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF940309), Color(0xFF0A0A0A)],
    stops: [0.0, 0.8],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A0A0A), Color(0x000A0A0A)],
  );
}
