import 'package:music4_mobile/features/auth/domain/entities/user_entity.dart';

class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final int id;
  final String username;
  final String name;
  final String? img;
  final String role;

  AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.id,
    required this.username,
    required this.name,
    this.img,
    required this.role,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      id: json['id'] as int? ?? 0,
      username: json['username'] as String? ?? '',
      name: json['name'] as String? ?? '',
      img: json['img'] as String?,
      role: json['role'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'id': id,
      'username': username,
      'name': name,
      'img': img,
      'role': role,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      displayName: name.isNotEmpty ? name : username,
      username: username,
      imageUrl: img,
      isArtist: role == 'ROLE_ARTIST',
    );
  }
}
