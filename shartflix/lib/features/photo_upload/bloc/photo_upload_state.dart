part of 'photo_upload_bloc.dart';

class PhotoUploadState extends Equatable {
  final File? selectedImage;
  final bool isUploading;
  final String? errorMessage;
  final bool uploadSuccess;

  const PhotoUploadState({
    this.selectedImage,
    this.isUploading = false,
    this.errorMessage,
    this.uploadSuccess = false,
  });

  PhotoUploadState copyWith({
    File? selectedImage,
    bool clearImage = false,
    bool? isUploading,
    String? errorMessage,
    bool clearError = false,
    bool? uploadSuccess,
  }) {
    return PhotoUploadState(
      selectedImage: clearImage ? null : (selectedImage ?? this.selectedImage),
      isUploading: isUploading ?? this.isUploading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      uploadSuccess: uploadSuccess ?? this.uploadSuccess,
    );
  }

  @override
  List<Object?> get props => [selectedImage, isUploading, errorMessage, uploadSuccess];
}
