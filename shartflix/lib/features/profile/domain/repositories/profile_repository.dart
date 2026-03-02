import 'package:dartz/dartz.dart';
import '../../../../core/utils/failures.dart';
import '../../../auth/domain/entities/user_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserEntity>> getProfile();
  Future<Either<Failure, String>> uploadPhoto(String filePath);
}
