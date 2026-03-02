import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/logger_service.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../home/domain/entities/movie_entity.dart';
import '../../../home/domain/usecases/get_favorites_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/upload_photo_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfile;
  final UploadPhotoUseCase uploadPhoto;
  final GetFavoritesUseCase getFavorites;
  final SecureStorageService secureStorage;

  ProfileBloc({
    required this.getProfile,
    required this.uploadPhoto,
    required this.getFavorites,
    required this.secureStorage,
  }) : super(const ProfileState()) {
    on<FetchProfile>(_onFetchProfile);
    on<UploadProfilePhoto>(_onUploadPhoto);
  }

  Future<void> _onFetchProfile(
    FetchProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    final profileResult = await getProfile();
    final favResult = await getFavorites();

    profileResult.fold(
      (failure) {
        logger.error('Fetch profile failed: ${failure.message}');
        emit(state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (user) {
        final favorites = favResult.fold(
          (_) => <MovieEntity>[],
          (favs) => favs,
        );
        emit(state.copyWith(
          status: ProfileStatus.success,
          user: user,
          favorites: favorites,
        ));
      },
    );
  }

  Future<void> _onUploadPhoto(
    UploadProfilePhoto event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isUploadingPhoto: true));

    final result = await uploadPhoto(event.filePath);

    result.fold(
      (failure) {
        logger.error('Upload photo failed: ${failure.message}');
        emit(state.copyWith(
          isUploadingPhoto: false,
          errorMessage: failure.message,
        ));
      },
      (photoUrl) {
        if (state.user != null) {
          final updatedUser = UserEntity(
            id: state.user!.id,
            name: state.user!.name,
            email: state.user!.email,
            photoUrl: photoUrl,
          );
          emit(state.copyWith(
            isUploadingPhoto: false,
            user: updatedUser,
          ));
        } else {
          emit(state.copyWith(isUploadingPhoto: false));
        }
      },
    );
  }
}
