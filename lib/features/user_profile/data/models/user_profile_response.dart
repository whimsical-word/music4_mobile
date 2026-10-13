import '../../domain/models/user_profile.dart';

class UserProfileResponse {
  final int id;
  final String name;
  final String? img;
  final String email;
  final bool? gender;
  final String role;
  final String username;

  const UserProfileResponse({
    required this.id,
    this.name = '',
    this.img,
    this.email = '',
    this.gender,
    this.role = '',
    this.username = '',
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      img: json['img'] as String?,
      email: json['email'] as String? ?? '',
      gender: json['gender'] as bool?,
      role: json['role'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'img': img,
      'email': email,
      'gender': gender,
      'role': role,
      'username': username,
    };
  }

  UserProfile toDomain() {
    return UserProfile(
      id: id.toString(),
      displayName: name.isNotEmpty ? name : username,
      email: email,
      avatarUrl: img ?? '',
      bio: '',
      followingCount: 0,
      playlistCount: 0,
      likedTracksCount: 0,
    );
  }

  UserProfileResponse copyWith({
    int? id,
    String? name,
    String? img,
    String? email,
    bool? gender,
    String? role,
    String? username,
  }) {
    return UserProfileResponse(
      id: id ?? this.id,
      name: name ?? this.name,
      img: img ?? this.img,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      role: role ?? this.role,
      username: username ?? this.username,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is UserProfileResponse &&
            other.id == id &&
            other.name == name &&
            other.img == img &&
            other.email == email &&
            other.gender == gender &&
            other.role == role &&
            other.username == username;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, img, email, gender, role, username);
  }

  @override
  String toString() {
    return 'UserProfileResponse('
        'id: $id, '
        'name: $name, '
        'img: $img, '
        'email: $email, '
        'gender: $gender, '
        'role: $role, '
        'username: $username'
        ')';
  }
}
