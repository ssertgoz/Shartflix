import 'package:dartz/dartz.dart';
import '../../../../core/utils/failures.dart';
import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

class GetFavoritesUseCase {
  final MovieRepository repository;
  GetFavoritesUseCase(this.repository);

  Future<Either<Failure, List<MovieEntity>>> call() {
    return repository.getFavorites();
  }
}
