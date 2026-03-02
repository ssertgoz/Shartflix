import 'package:dartz/dartz.dart';
import '../../../../core/utils/failures.dart';
import '../entities/movie_entity.dart';

abstract class MovieRepository {
  Future<Either<Failure, ({List<MovieEntity> movies, int totalPages, int currentPage})>> getMovies(int page);
  Future<Either<Failure, bool>> toggleFavorite(String movieId);
  Future<Either<Failure, List<MovieEntity>>> getFavorites();
}
