import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../services/secure_storage_service.dart';
import '../services/locale_notifier.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/home/data/datasources/movie_remote_datasource.dart';
import '../../features/home/data/repositories/movie_repository_impl.dart';
import '../../features/home/domain/repositories/movie_repository.dart';
import '../../features/home/domain/usecases/get_movies_usecase.dart';
import '../../features/home/domain/usecases/toggle_favorite_usecase.dart';
import '../../features/home/domain/usecases/get_favorites_usecase.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/domain/usecases/upload_photo_usecase.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/photo_upload/bloc/photo_upload_bloc.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  // Services
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  sl.registerLazySingleton<LocaleNotifier>(() => LocaleNotifier(sl()));
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));

  // Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        registerUseCase: sl(),
        secureStorage: sl(),
      ));

  // Home / Movies
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetMoviesUseCase(sl()));
  sl.registerLazySingleton(() => ToggleFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => GetFavoritesUseCase(sl()));
  sl.registerFactory(() => HomeBloc(
        getMovies: sl(),
        toggleFavorite: sl(),
        getFavorites: sl(),
      ));

  // Profile
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UploadPhotoUseCase(sl()));
  sl.registerFactory(() => PhotoUploadBloc(uploadPhoto: sl()));
  sl.registerFactory(() => ProfileBloc(
        getProfile: sl(),
        uploadPhoto: sl(),
        getFavorites: sl(),
        secureStorage: sl(),
      ));
}
