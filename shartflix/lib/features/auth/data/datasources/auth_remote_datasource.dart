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
      return _parseAuthResponse(response.data);
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
      return _parseAuthResponse(response.data);
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }

  /// Parses API response. Handles both:
  /// - Wrapped: { response: { code, message }, data: { id, name, email, photoUrl, token } }
  /// - Flat: { token, user: { id, name, email } }
  ({String token, UserModel user}) _parseAuthResponse(dynamic raw) {
    final map = raw as Map<String, dynamic>;

    Map<String, dynamic> data;
    if (map.containsKey('data') && map['data'] is Map<String, dynamic>) {
      data = map['data'] as Map<String, dynamic>;
    } else {
      data = map;
    }

    final token = data['token'] as String? ?? '';
    if (token.isEmpty) {
      throw const UnknownFailure('No token in response');
    }

    final userMap = data.containsKey('user') && data['user'] is Map<String, dynamic>
        ? data['user'] as Map<String, dynamic>
        : data;

    final user = UserModel.fromJson(userMap);
    return (token: token, user: user);
  }
}
