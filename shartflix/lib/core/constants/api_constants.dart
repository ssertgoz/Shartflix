class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://caseapi.servicelabs.tech';

  // Auth
  static const String login = '/user/login';
  static const String register = '/user/register';
  static const String profile = '/user/profile';
  static const String uploadPhoto = '/user/upload_photo';

  // Movies
  static const String movieList = '/movie/list';
  static const String movieFavorites = '/movie/favorites';
  static String movieFavorite(String id) => '/movie/favorite/$id';

  static const int moviesPerPage = 5;
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
