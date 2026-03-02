import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/failures.dart';
import '../models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<({List<MovieModel> movies, int totalPages, int currentPage})> getMovies(int page);
  Future<bool> toggleFavorite(String movieId);
  Future<List<MovieModel>> getFavorites();
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final ApiClient _apiClient;
  MovieRemoteDataSourceImpl(this._apiClient);

  @override
  Future<({List<MovieModel> movies, int totalPages, int currentPage})> getMovies(int page) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.movieList,
        queryParameters: {'page': page},
      );
      final data = response.data as Map<String, dynamic>;
      final moviesList = (data['movies'] as List<dynamic>?)
              ?.map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
      return (
        movies: moviesList,
        totalPages: data['totalPages'] as int? ?? 1,
        currentPage: data['currentPage'] as int? ?? page,
      );
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }

  @override
  Future<bool> toggleFavorite(String movieId) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.movieFavorite(movieId),
      );
      final data = response.data as Map<String, dynamic>;
      return data['success'] as bool? ?? true;
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }

  @override
  Future<List<MovieModel>> getFavorites() async {
    try {
      final response = await _apiClient.get(ApiConstants.movieFavorites);
      final data = response.data as Map<String, dynamic>;
      return (data['movies'] as List<dynamic>?)
              ?.map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }
}
