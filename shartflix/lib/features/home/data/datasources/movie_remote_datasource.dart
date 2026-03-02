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
      return _parseMovieListResponse(response.data, page: page);
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
      final map = response.data as Map<String, dynamic>;
      final data = map['data'] is Map<String, dynamic> ? map['data'] as Map<String, dynamic> : map;
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
      final map = response.data as Map<String, dynamic>;

      // Unwrap optional top-level `data` envelope
      final payload = map['data'] is Map<String, dynamic>
          ? map['data'] as Map<String, dynamic>
          : map;

      // The favorites endpoint returns movies with lowercase keys
      // (id, title, description, posterUrl) — MovieModel.fromJson handles both
      final rawList = payload['movies'] as List<dynamic>? ?? const [];
      return rawList
          .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }

  /// Parses the wrapped movie list response:
  /// {
  ///   "response": { "code": 200, "message": "" },
  ///   "data": {
  ///     "movies": [ ... ],
  ///     "totalPages": 1,
  ///     "currentPage": 1
  ///   }
  /// }
  ({List<MovieModel> movies, int totalPages, int currentPage}) _parseMovieListResponse(
    dynamic raw, {
    required int page,
  }) {
    final map = raw as Map<String, dynamic>;
    final data = map['data'] is Map<String, dynamic> ? map['data'] as Map<String, dynamic> : map;

    final rawList = data['movies'] as List<dynamic>? ?? const [];
    final movies = rawList
        .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
        .toList();

    // Pagination block shape:
    // "pagination": { "totalCount": 16, "perPage": 5, "maxPage": 4, "currentPage": 1 }
    final pagination = data['pagination'] as Map<String, dynamic>? ?? const {};
    final totalPages = pagination['maxPage'] as int? ?? 1;
    final currentPage = pagination['currentPage'] as int? ?? page;

    return (movies: movies, totalPages: totalPages, currentPage: currentPage);
  }
}
