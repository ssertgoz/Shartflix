import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/failures.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<({String token, UserModel user})> login({
    required String email,
    required String password,
  });

  Future<({String token, UserModel user})> register({
    required String email,
    required String password,
    required String name,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;
  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<({String token, UserModel user})> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );
      final data = response.data as Map<String, dynamic>;
      return (
        token: data['token'] as String,
        user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }

  @override
  Future<({String token, UserModel user})> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.register,
        data: {'email': email, 'password': password, 'name': name},
      );
      final data = response.data as Map<String, dynamic>;
      return (
        token: data['token'] as String,
        user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }
}
