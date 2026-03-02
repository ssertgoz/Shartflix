import 'package:equatable/equatable.dart';

class MovieEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String posterUrl;
  final List<String> images;
  final bool isFavorite;

  const MovieEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    this.images = const [],
    this.isFavorite = false,
  });

  /// Returns the best available image URL. Tries `posterUrl` first; if empty
  /// or the caller marks it as failed, falls back through `images`.
  String get bestPosterUrl => posterUrl.isNotEmpty ? posterUrl : (images.isNotEmpty ? images.first : '');

  MovieEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? posterUrl,
    List<String>? images,
    bool? isFavorite,
  }) {
    return MovieEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      posterUrl: posterUrl ?? this.posterUrl,
      images: images ?? this.images,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [id, title, description, posterUrl, images, isFavorite];
}
