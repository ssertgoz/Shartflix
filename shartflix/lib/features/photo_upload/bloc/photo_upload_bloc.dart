import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/logger_service.dart';
import '../../profile/domain/usecases/upload_photo_usecase.dart';

part 'photo_upload_event.dart';
part 'photo_upload_state.dart';

class PhotoUploadBloc extends Bloc<PhotoUploadEvent, PhotoUploadState> {
  final UploadPhotoUseCase uploadPhoto;

  PhotoUploadBloc({required this.uploadPhoto}) : super(const PhotoUploadState()) {
    on<PhotoImagePicked>(_onImagePicked);
    on<PhotoImageRemoved>(_onImageRemoved);
    on<PhotoUploadSubmitted>(_onUploadSubmitted);
  }

  void _onImagePicked(PhotoImagePicked event, Emitter<PhotoUploadState> emit) {
    emit(state.copyWith(selectedImage: event.image, clearError: true));
  }

  void _onImageRemoved(PhotoImageRemoved event, Emitter<PhotoUploadState> emit) {
    emit(state.copyWith(clearImage: true, clearError: true));
  }

  Future<void> _onUploadSubmitted(
    PhotoUploadSubmitted event,
    Emitter<PhotoUploadState> emit,
  ) async {
    if (state.selectedImage == null) return;

    emit(state.copyWith(isUploading: true, clearError: true));

    final result = await uploadPhoto(state.selectedImage!.path);

    result.fold(
      (failure) {
        logger.error('Photo upload failed: ${failure.message}');
        emit(state.copyWith(isUploading: false, errorMessage: failure.message));
      },
      (_) {
        emit(state.copyWith(isUploading: false, uploadSuccess: true));
      },
    );
  }
}
