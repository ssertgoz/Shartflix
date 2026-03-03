import 'package:dio/dio.dart';
import '../utils/failures.dart';

Failure handleDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      return const NetworkFailure('Connection timed out');
    case DioExceptionType.connectionError:
      return const NetworkFailure('No internet connection');
    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      final message = _extractMessage(e.response?.data);
      if (statusCode == 401) {
        return const UnauthorizedFailure();
      }
      return ServerFailure(message ?? 'Server error ($statusCode)');
    default:
      return UnknownFailure(e.message ?? 'Unknown error');
  }
}

String? _extractMessage(dynamic data) {
  if (data == null) return null;
  if (data is Map<String, dynamic>) {
    final direct = data['message'] as String? ?? data['error'] as String?;
    if (direct != null && direct.isNotEmpty) return direct;
    final nested = data['response'];
    if (nested is Map<String, dynamic>) {
      return nested['message'] as String?;
    }
  }
  return data.toString();
}
