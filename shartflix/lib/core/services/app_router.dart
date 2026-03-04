import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/photo_upload/pages/photo_upload_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../constants/app_assets.dart';
import '../di/injection.dart';
import 'secure_storage_service.dart';
import 'navigation_service.dart';
import '../constants/app_routes.dart';
import '../theme/app_colors.dart';

class AppRouter {
  AppRouter._();

  /// Creates a single [GoRouter] instance. Call once from [main] and pass to
  /// [MaterialApp.router] so hot reload keeps the current route instead of
  /// re-initializing from splash.
  static GoRouter createRouter() => GoRouter(
        navigatorKey: NavigationService.navigatorKey,
        initialLocation: AppRoutes.splash,
        redirect: _guardRedirect,
        routes: [
          GoRoute(
            path: AppRoutes.splash,
            builder: (_, __) => const SplashPage(),
          ),
          GoRoute(
            path: AppRoutes.login,
            builder: (_, __) => const LoginPage(),
          ),
          GoRoute(
            path: AppRoutes.register,
            builder: (_, __) => const RegisterPage(),
          ),
          GoRoute(
            path: AppRoutes.photoUpload,
            builder: (_, __) => const PhotoUploadPage(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (_, __) => const SettingsPage(),
          ),
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) => BlocProvider<ProfileBloc>(
              create: (_) => sl<ProfileBloc>(),
              child: _MainShell(
                navigationShell: navigationShell,
                location: state.uri.toString(),
              ),
            ),
            branches: [
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: AppRoutes.home,
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: HomePage(),
                    ),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: AppRoutes.profile,
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: ProfilePage(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );

  static Future<String?> _guardRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final storage = sl<SecureStorageService>();
    final hasToken = await storage.hasToken();
    final isAuthRoute = state.uri.toString() == AppRoutes.login ||
        state.uri.toString() == AppRoutes.register ||
        state.uri.toString() == AppRoutes.splash;

    if (!hasToken && !isAuthRoute) {
      return AppRoutes.login;
    }
    return null;
  }
}

class _MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final String location;

  const _MainShell({
    required this.navigationShell,
    required this.location,
  });

  int get _selectedIndex => location.startsWith(AppRoutes.profile) ? 1 : 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: navigationShell),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomNav(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final isHome = _selectedIndex == 0;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        child: Row(
          children: [
            Expanded(
              child: _NavButton(
                svgPath: isHome ? AppAssets.icons.homeFill : AppAssets.icons.home,
                label: 'Anasayfa',
                isSelected: isHome,
                onTap: () {
                  if (_selectedIndex != 0) {
                    NavigationService.go(AppRoutes.home);
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _NavButton(
                svgPath: isHome ? AppAssets.icons.profile : AppAssets.icons.profileFill,
                label: 'Profil',
                isSelected: _selectedIndex == 1,
                onTap: () {
                  if (_selectedIndex != 1) {
                    NavigationService.go(AppRoutes.profile);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String svgPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavButton({
    required this.svgPath,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.navButtonActiveGradient : null,
            color: isSelected ? null : AppColors.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.white20, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                svgPath,
                width: 22,
                height: 22,
                colorFilter: ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
