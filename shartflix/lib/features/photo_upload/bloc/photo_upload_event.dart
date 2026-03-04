part of 'photo_upload_bloc.dart';

abstract class PhotoUploadEvent extends Equatable {
  const PhotoUploadEvent();

  @override
  List<Object?> get props => [];
}

class PhotoImagePicked extends PhotoUploadEvent {
  final File image;
  const PhotoImagePicked(this.image);

  @override
  List<Object?> get props => [image];
}

class PhotoImageRemoved extends PhotoUploadEvent {
  const PhotoImageRemoved();
}

class PhotoUploadSubmitted extends PhotoUploadEvent {
  const PhotoUploadSubmitted();
}
