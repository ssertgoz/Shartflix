import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../home/domain/entities/movie_entity.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/limited_offer_bottom_sheet.dart';
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
        backgroundColor: AppColors.background,
        body: BlocBuilder<ProfileBloc, ProfileState>(
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
                    const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage ?? l10n.unknownError,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ProfileBloc>().add(const FetchProfile()),
                      child: Text(l10n.tryAgain),
                    ),
                  ],
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                _buildAppBar(context, state, l10n),
                _buildProfileHeader(context, state, l10n),
                _buildFavoritesSection(context, state, l10n),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    ProfileState state,
    AppLocalizations l10n,
  ) {
    return SliverAppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      floating: true,
      title: Text(l10n.myProfile, style: Theme.of(context).textTheme.titleLarge),
      actions: [
        TextButton.icon(
          onPressed: () => showLimitedOfferBottomSheet(context),
          icon: const Icon(Icons.local_offer, color: AppColors.primary, size: 18),
          label: Text(
            'Sınır Teklif',
            style: const TextStyle(color: AppColors.primary, fontSize: 13),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: AppColors.textSecondary),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: AppColors.surfaceElevated,
                title: const Text('Çıkış Yap', style: TextStyle(color: AppColors.textPrimary)),
                content: const Text('Hesabınızdan çıkmak istiyor musunuz?',
                    style: TextStyle(color: AppColors.textSecondary)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('İptal', style: TextStyle(color: AppColors.textSecondary)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<AuthBloc>().add(const LogoutRequested());
                    },
                    child: Text(l10n.logout,
                        style: const TextStyle(color: AppColors.primary)),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    ProfileState state,
    AppLocalizations l10n,
  ) {
    final user = state.user;
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => _pickAndUploadPhoto(context),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  _buildAvatar(state, user?.photoUrl),
                  if (state.isUploadingPhoto)
                    const Positioned.fill(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, size: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.name ?? '',
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _StatChip(
                        label: '${state.favorites.length}',
                        sublabel: l10n.favorites,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(ProfileState state, String? photoUrl) {
    const size = 72.0;
    if (photoUrl != null && photoUrl.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: photoUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (_, __) => _avatarPlaceholder(size),
          errorWidget: (_, __, ___) => _avatarPlaceholder(size),
        ),
      );
    }
    return _avatarPlaceholder(size);
  }

  Widget _avatarPlaceholder(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 36),
    );
  }

  Widget _buildFavoritesSection(
    BuildContext context,
    ProfileState state,
    AppLocalizations l10n,
  ) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                l10n.favorites,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          if (state.favorites.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.favorite_border,
                        size: 48,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.noFavorites,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final movie = state.favorites[index];
                  return _FavoriteMovieTile(movie: movie);
                },
                childCount: state.favorites.length,
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String sublabel;

  const _StatChip({required this.label, required this.sublabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.favorite, size: 12, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            '$label $sublabel',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteMovieTile extends StatelessWidget {
  final MovieEntity movie;

  const _FavoriteMovieTile({required this.movie});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        fit: StackFit.expand,
        children: [
          movie.posterUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: movie.posterUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: AppColors.shimmer),
                  errorWidget: (_, __, ___) => Container(
                    color: AppColors.surfaceElevated,
                    child: const Icon(Icons.movie_outlined,
                        color: AppColors.textHint),
                  ),
                )
              : Container(
                  color: AppColors.surfaceElevated,
                  child: const Icon(Icons.movie_outlined,
                      color: AppColors.textHint),
                ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                gradient: AppColors.cardGradient,
              ),
              child: Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
