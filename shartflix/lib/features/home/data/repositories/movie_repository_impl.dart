import 'package:dartz/dartz.dart';
import '../../../../core/utils/failures.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_datasource.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource _remoteDataSource;
  MovieRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, ({List<MovieEntity> movies, int totalPages, int currentPage})>> getMovies(int page) async {
    try {
      final result = await _remoteDataSource.getMovies(page);
      return Right((
        movies: result.movies,
        totalPages: result.totalPages,
        currentPage: result.currentPage,
      ));
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite(String movieId) async {
    try {
      final result = await _remoteDataSource.toggleFavorite(movieId);
      return Right(result);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> getFavorites() async {
    try {
      final result = await _remoteDataSource.getFavorites();
      return Right(result);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
