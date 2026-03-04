import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:shartflix/core/constants/app_assets.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/auth_background.dart';
import '../../../core/widgets/close_button_circle.dart';
import '../../auth/presentation/widgets/auth_button.dart';
import '../bloc/photo_upload_bloc.dart';
import 'package:shartflix/l10n/app_localizations.dart';

class PhotoUploadPage extends StatelessWidget {
  const PhotoUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PhotoUploadBloc>(),
      child: const _PhotoUploadView(),
    );
  }
}

class _PhotoUploadView extends StatelessWidget {
  const _PhotoUploadView();

  void _navigateBack() {
    if (NavigationService.canPop()) {
      NavigationService.pop();
    } else {
      NavigationService.go(AppRoutes.home);
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 800,
    );
    if (image != null && context.mounted) {
      context.read<PhotoUploadBloc>().add(PhotoImagePicked(File(image.path)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocListener<PhotoUploadBloc, PhotoUploadState>(
      listener: (context, state) {
        if (state.uploadSuccess) {
          _navigateBack();
          return;
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AuthBackground(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SafeArea(
                bottom: false,
                child: _buildAppBar(context, l10n),
              ),
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
                    BlocBuilder<PhotoUploadBloc, PhotoUploadState>(
                      builder: (context, state) => _buildPhotoArea(context, state),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: BlocBuilder<PhotoUploadBloc, PhotoUploadState>(
                        builder: (context, state) => AuthButton(
                          label: l10n.continueButton,
                          isLoading: state.isUploading,
                          onPressed: () => _onContinue(context, state),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    BlocBuilder<PhotoUploadBloc, PhotoUploadState>(
                      builder: (context, state) => TextButton(
                        onPressed: state.isUploading ? null : () => _navigateBack(),
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
  }

  void _onContinue(BuildContext context, PhotoUploadState state) {
    if (state.selectedImage != null) {
      context.read<PhotoUploadBloc>().add(const PhotoUploadSubmitted());
    } else {
      _navigateBack();
    }
  }

  Widget _buildAppBar(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          InkWell(
            onTap: () => _navigateBack(),
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

  Widget _buildPhotoArea(BuildContext context, PhotoUploadState state) {
    final File? image = state.selectedImage;
    return GestureDetector(
      onTap: image == null ? () => _pickImage(context) : null,
      child: Column(
        children: [
          Container(
            width: 176,
            height: 176,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              border: image != null
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
              child: image != null
                  ? Image.file(image, fit: BoxFit.cover)
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
            opacity: image != null ? 1 : 0,
            child: CloseButtonCircle(
              size: 36,
              onPressed: image != null
                  ? () => context.read<PhotoUploadBloc>().add(const PhotoImageRemoved())
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
