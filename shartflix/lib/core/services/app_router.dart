import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../constants/app_assets.dart';
import '../di/injection.dart';
import 'secure_storage_service.dart';
import 'navigation_service.dart';
import '../constants/app_routes.dart';
import '../theme/app_colors.dart';

class AppRouter {
  AppRouter._();

  static GoRouter get router => GoRouter(
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
          ShellRoute(
            builder: (context, state, child) => _MainShell(
              location: state.uri.toString(),
              child: child,
            ),
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (_, __) => const HomePage(),
              ),
              GoRoute(
                path: AppRoutes.profile,
                builder: (_, __) => const ProfilePage(),
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

class _MainShell extends StatefulWidget {
  final Widget child;
  final String location;

  const _MainShell({required this.child, required this.location});

  @override
  State<_MainShell> createState() => _MainShellState();
}

class _NavItem extends StatelessWidget {
  final String svgPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.svgPath,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isSelected ? AppColors.primary : AppColors.textHint,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'InstrumentSans',
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.primary : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainShellState extends State<_MainShell> {
  int _selectedIndex = 0;

  @override
  void didUpdateWidget(_MainShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateIndex(widget.location);
  }

  void _updateIndex(String location) {
    if (location.startsWith(AppRoutes.profile)) {
      setState(() => _selectedIndex = 1);
    } else {
      setState(() => _selectedIndex = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.navBackground,
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              _NavItem(
                svgPath: _selectedIndex == 0
                    ? AppAssets.icons.homeFill
                    : AppAssets.icons.home,
                label: 'Ana Sayfa',
                isSelected: _selectedIndex == 0,
                onTap: () {
                  setState(() => _selectedIndex = 0);
                  context.go(AppRoutes.home);
                },
              ),
              _NavItem(
                svgPath: _selectedIndex == 1
                    ? AppAssets.icons.profileFill
                    : AppAssets.icons.profile,
                label: 'Profil',
                isSelected: _selectedIndex == 1,
                onTap: () {
                  setState(() => _selectedIndex = 1);
                  context.go(AppRoutes.profile);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
