import 'package:dartz/dartz.dart';
import '../../../../core/utils/failures.dart';
import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

class GetMoviesUseCase {
  final MovieRepository repository;
  GetMoviesUseCase(this.repository);

  Future<Either<Failure, ({List<MovieEntity> movies, int totalPages, int currentPage})>> call(int page) {
    return repository.getMovies(page);
  }
}
