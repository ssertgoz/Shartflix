import 'package:dartz/dartz.dart';
import '../../../../core/utils/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  Future<Either<Failure, ({String token, UserEntity user})>> call({
    required String email,
    required String password,
    required String name,
  }) {
    return repository.register(email: email, password: password, name: name);
  }
}
