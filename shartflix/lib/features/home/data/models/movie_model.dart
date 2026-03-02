import '../../domain/entities/movie_entity.dart';

class MovieModel extends MovieEntity {
  const MovieModel({
    required super.id,
    required super.title,
    required super.description,
    required super.posterUrl,
    super.images,
    super.isFavorite,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String? ?? json['_id']?.toString() ?? '';

    final rawImages = json['Images'] as List<dynamic>? ?? const [];
    final images = rawImages.whereType<String>().toList();

    // Prefer Poster; fall back to first image if Poster is empty
    final rawPoster = (json['Poster'] ?? json['posterUrl'] ?? '') as String;
    final posterUrl = rawPoster.isNotEmpty ? rawPoster : (images.isNotEmpty ? images.first : '');

    return MovieModel(
      id: id,
      title: (json['Title'] ?? json['title'] ?? '') as String,
      description: (json['Plot'] ?? json['description'] ?? '') as String,
      posterUrl: posterUrl,
      images: images,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Title': title,
      'Plot': description,
      'Poster': posterUrl,
      'Images': images,
    };
  }
}
