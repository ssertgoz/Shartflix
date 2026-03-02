import 'package:dartz/dartz.dart';
import '../../../../core/utils/failures.dart';
import '../repositories/movie_repository.dart';

class ToggleFavoriteUseCase {
  final MovieRepository repository;
  ToggleFavoriteUseCase(this.repository);

  Future<Either<Failure, bool>> call(String movieId) {
    return repository.toggleFavorite(movieId);
  }
}
