import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/failures.dart';
import '../../../auth/data/models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getProfile();
  Future<String> uploadPhoto(String filePath);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient _apiClient;
  ProfileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await _apiClient.get(ApiConstants.profile);
      final map = response.data as Map<String, dynamic>;
      // API returns { response: {...}, data: { _id, id, name, email, photoUrl } }
      final data = map['data'] is Map<String, dynamic>
          ? map['data'] as Map<String, dynamic>
          : map;
      return UserModel.fromJson(data);
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }

  @override
  Future<String> uploadPhoto(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      final response = await _apiClient.post(
        ApiConstants.uploadPhoto,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      final map = response.data as Map<String, dynamic>;
      // API returns { response: {...}, data: { _id, id, name, email, photoUrl } }
      final data = map['data'] is Map<String, dynamic>
          ? map['data'] as Map<String, dynamic>
          : map;
      final photoUrl = data['photoUrl'] as String? ?? '';
      return photoUrl;
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }
}
