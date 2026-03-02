import 'package:dartz/dartz.dart';
import '../../../../core/utils/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, ({String token, UserEntity user})>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, ({String token, UserEntity user})>> register({
    required String email,
    required String password,
    required String name,
  });
}
