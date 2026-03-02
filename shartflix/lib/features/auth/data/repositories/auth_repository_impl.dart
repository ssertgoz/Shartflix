import 'package:dartz/dartz.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/utils/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorage;

  AuthRepositoryImpl(this._remoteDataSource, this._secureStorage);

  @override
  Future<Either<Failure, ({String token, UserEntity user})>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      await _secureStorage.saveToken(result.token);
      await _secureStorage.saveUserId(result.user.id);
      return Right((token: result.token, user: result.user));
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ({String token, UserEntity user})>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final result = await _remoteDataSource.register(
        email: email,
        password: password,
        name: name,
      );
      await _secureStorage.saveToken(result.token);
      await _secureStorage.saveUserId(result.user.id);
      return Right((token: result.token, user: result.user));
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
