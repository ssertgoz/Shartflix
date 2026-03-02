import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String? ?? json['_id']?.toString() ?? '';
    final photoUrlRaw = json['photoUrl'];
    final photoUrl = photoUrlRaw is String && photoUrlRaw.isNotEmpty
        ? photoUrlRaw
        : null;
    return UserModel(
      id: id,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      photoUrl: photoUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      if (photoUrl != null) 'photoUrl': photoUrl,
    };
  }
}
