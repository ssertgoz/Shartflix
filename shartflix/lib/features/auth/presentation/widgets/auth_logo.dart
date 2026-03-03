import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';

/// Centered app icon logo for login and register screens.
class AuthLogo extends StatelessWidget {
  final double size;

  const AuthLogo({super.key, this.size = 90});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Image.asset(
          AppAssets.images.appIcon,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
