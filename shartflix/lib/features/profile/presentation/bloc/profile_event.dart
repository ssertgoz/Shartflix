part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class FetchProfile extends ProfileEvent {
  const FetchProfile();
}

class UploadProfilePhoto extends ProfileEvent {
  final String filePath;
  const UploadProfilePhoto(this.filePath);

  @override
  List<Object> get props => [filePath];
}
