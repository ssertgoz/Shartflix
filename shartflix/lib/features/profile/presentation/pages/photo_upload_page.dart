import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
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
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (!_isUploading) return;
          if (!state.isUploadingPhoto) {
            setState(() => _isUploading = false);
            if (!mounted) return;
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: AppColors.error,
                ),
              );
            } else {
              if (Navigator.canPop(context)) {
                context.pop();
              } else {
                context.go(AppRoutes.home);
              }
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: AppColors.textPrimary, size: 20),
              onPressed: () => _onBack(context),
            ),
            title: Text(
              l10n.profileDetail,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'InstrumentSans',
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: AuthBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    const Icon(
                      Icons.person_outline_rounded,
                      size: 64,
                      color: AppColors.textSecondary,
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
                    Text(
                      l10n.photoUploadSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.4,
                        fontFamily: 'InstrumentSans',
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildPhotoArea(context),
                    const SizedBox(height: 48),
                    AuthButton(
                      label: l10n.continueButton,
                      isLoading: _isUploading,
                      onPressed: () => _onContinue(context),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _isUploading ? null : () => _onSkip(context),
                      child: Text(
                        l10n.skipButton,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'InstrumentSans',
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoArea(BuildContext context) {
    return GestureDetector(
      onTap: _selectedImage == null ? _pickImage : null,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.inputBorder,
                width: 2,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
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
                  : CustomPaint(
                      painter: _DashedBorderPainter(),
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          size: 64,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
            ),
          ),
          if (_selectedImage != null)
            Positioned(
              bottom: -12,
              child: GestureDetector(
                onTap: _removeImage,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.inputBorder),
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
            ),
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.inputBorder
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    const dashWidth = 8;
    const dashSpace = 6;

    void drawDashedHorizontal(double y) {
      for (double x = 0; x < size.width; x += dashWidth + dashSpace) {
        final endX = (x + dashWidth).clamp(0.0, size.width);
        if (endX > x) canvas.drawLine(Offset(x, y), Offset(endX, y), paint);
      }
    }

    void drawDashedVertical(double x) {
      for (double y = 0; y < size.height; y += dashWidth + dashSpace) {
        final endY = (y + dashWidth).clamp(0.0, size.height);
        if (endY > y) canvas.drawLine(Offset(x, y), Offset(x, endY), paint);
      }
    }

    drawDashedHorizontal(0);
    drawDashedHorizontal(size.height);
    drawDashedVertical(0);
    drawDashedVertical(size.width);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
