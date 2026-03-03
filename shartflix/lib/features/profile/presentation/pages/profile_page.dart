import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/favorites_section.dart';
import '../widgets/limited_offer_bottom_sheet.dart';
import '../widgets/profile_app_bar.dart';
import '../widgets/profile_header.dart';
import 'package:shartflix/l10n/app_localizations.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ProfileBloc>()..add(const FetchProfile()),
        ),
        BlocProvider(create: (_) => sl<AuthBloc>()),
      ],
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  Future<void> _pickAndUploadPhoto(BuildContext context) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 800,
    );
    if (image != null && context.mounted) {
      context.read<ProfileBloc>().add(UploadProfilePhoto(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          context.go(AppRoutes.login);
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppColors.profilePageGradient,
          ),
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state.status == ProfileStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (state.status == ProfileStatus.failure && state.user == null) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          color: AppColors.error, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        state.errorMessage ?? l10n.unknownError,
                        style: const TextStyle(
                            color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context
                            .read<ProfileBloc>()
                            .add(const FetchProfile()),
                        child: Text(l10n.tryAgain),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ProfileAppBar(
                      l10n: l10n,
                      onLimitedOfferTap: () =>
                          showLimitedOfferBottomSheet(context),
                    ),
                    ProfileHeader(
                      user: state.user,
                      isUploadingPhoto: state.isUploadingPhoto,
                      onPickPhoto: () => _pickAndUploadPhoto(context),
                      l10n: l10n,
                    ),
                    FavoritesSection(
                      favorites: state.favorites,
                      l10n: l10n,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
