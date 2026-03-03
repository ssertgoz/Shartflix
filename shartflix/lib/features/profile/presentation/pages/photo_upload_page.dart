import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:shartflix/core/constants/app_assets.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/auth_background.dart';
import '../../../auth/presentation/widgets/auth_button.dart';
import '../bloc/profile_bloc.dart';
import 'package:shartflix/l10n/app_localizations.dart';

class PhotoUploadPage extends StatefulWidget {
  const PhotoUploadPage({super.key});

  @override
  State<PhotoUploadPage> createState() => _PhotoUploadPageState();
}

class _PhotoUploadPageState extends State<PhotoUploadPage> {
  File? _selectedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 800,
    );
    if (image != null && mounted) {
      setState(() => _selectedImage = File(image.path));
    }
  }

  void _removeImage() {
    setState(() => _selectedImage = null);
  }

  void _onBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }

  Future<void> _onContinue(BuildContext context) async {
    if (_selectedImage != null) {
      setState(() => _isUploading = true);
      context.read<ProfileBloc>().add(UploadProfilePhoto(_selectedImage!.path));
    } else {
      if (Navigator.canPop(context)) {
        context.pop();
      } else {
        context.go(AppRoutes.home);
      }
    }
  }

  void _onSkip(BuildContext context) {
    if (Navigator.canPop(context)) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => sl<ProfileBloc>(),
      child: Builder(
        builder: (ctx) {
          return BlocListener<ProfileBloc, ProfileState>(
            listener: (ctx, state) {
              if (!_isUploading) return;
              if (!state.isUploadingPhoto) {
                setState(() => _isUploading = false);
                if (!mounted) return;
                if (state.errorMessage != null) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage!),
                      backgroundColor: AppColors.error,
                    ),
                  );
                } else {
                  if (Navigator.canPop(ctx)) {
                    ctx.pop();
                  } else {
                    ctx.go(AppRoutes.home);
                  }
                }
              }
            },
            child: Scaffold(
          backgroundColor: Colors.transparent,
          body: AuthBackground(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SafeArea(bottom: false, child: _buildCustomAppBar(ctx, l10n)),
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(height: 52),
                      SvgPicture.asset(
                        AppAssets.images.photoUploadProfile,
                        width: 76,
                        height: 76,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l10n.uploadPhoto,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'InstrumentSans',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 48),
                        child: Text(
                          l10n.photoUploadSubtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.white90,
                            fontSize: 14,
                            height: 1.4,
                            fontFamily: 'InstrumentSans',
                          ),
                        ),
                      ),
                      const SizedBox(height: 52),
                      _buildPhotoArea(ctx),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: AuthButton(
                          label: l10n.continueButton,
                          isLoading: _isUploading,
                          onPressed: () => _onContinue(ctx),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _isUploading ? null : () => _onSkip(ctx),
                        child: Text(
                          l10n.skipButton,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'InstrumentSans',
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
            );
        },
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          InkWell(
            onTap: () => _onBack(context),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 44,
              height: 44,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                border: Border.all(color: AppColors.inputBorder),
                borderRadius: BorderRadius.circular(16),
              ),
              child: SvgPicture.asset(
                AppAssets.icons.arrow,
                width: 24,
                height: 24,
              ),
            ),
          ),
          Expanded(
            child: Text(
              l10n.profileDetail,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'InstrumentSans',
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildPhotoArea(BuildContext context) {
    return GestureDetector(
      onTap: _selectedImage == null ? _pickImage : null,
      child: Column(
        children: [
          Container(
            width: 176,
            height: 176,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              border: _selectedImage != null
                  ? null
                  : DashedBorder.fromBorderSide(
                      dashLength: 8,
                      side: const BorderSide(
                        color: AppColors.inputBorder,
                        width: 2,
                      ),
                    ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: _selectedImage != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      ],
                    )
                  : const Center(
                      child: Icon(
                        Icons.add,
                        size: 32,
                        color: AppColors.textSecondary,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Opacity(
            opacity: _selectedImage != null ? 1 : 0,
            child: GestureDetector(
              onTap: _removeImage,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.close,
                  color: AppColors.textPrimary,
                  size: 24,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
