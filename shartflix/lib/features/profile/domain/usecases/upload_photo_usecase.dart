import 'package:dartz/dartz.dart';
import '../../../../core/utils/failures.dart';
import '../repositories/profile_repository.dart';

class UploadPhotoUseCase {
  final ProfileRepository repository;
  UploadPhotoUseCase(this.repository);

  Future<Either<Failure, String>> call(String filePath) {
    return repository.uploadPhoto(filePath);
  }
}
