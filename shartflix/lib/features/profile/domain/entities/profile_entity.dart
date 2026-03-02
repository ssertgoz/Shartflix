import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../home/domain/entities/movie_entity.dart';

class ProfileEntity extends Equatable {
  final UserEntity user;
  final List<MovieEntity> favorites;

  const ProfileEntity({required this.user, this.favorites = const []});

  ProfileEntity copyWith({UserEntity? user, List<MovieEntity>? favorites}) {
    return ProfileEntity(
      user: user ?? this.user,
      favorites: favorites ?? this.favorites,
    );
  }

  @override
  List<Object?> get props => [user, favorites];
}
