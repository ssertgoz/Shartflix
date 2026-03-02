part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, success, failure, uploadingPhoto }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserEntity? user;
  final List<MovieEntity> favorites;
  final String? errorMessage;
  final bool isUploadingPhoto;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.favorites = const [],
    this.errorMessage,
    this.isUploadingPhoto = false,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserEntity? user,
    List<MovieEntity>? favorites,
    String? errorMessage,
    bool? isUploadingPhoto,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      favorites: favorites ?? this.favorites,
      errorMessage: errorMessage,
      isUploadingPhoto: isUploadingPhoto ?? this.isUploadingPhoto,
    );
  }

  @override
  List<Object?> get props => [status, user, favorites, errorMessage, isUploadingPhoto];
}
