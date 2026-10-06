import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:music4_mobile/features/auth/domain/entities/user_entity.dart';

class TokenStorage {
  final FlutterSecureStorage _storage;

  @Deprecated(
    'Ưu tiên sử dụng Dependency Injection hoặc TokenStorage() thay vì gọi singleton instance.',
  )
  static final TokenStorage instance = TokenStorage();

  TokenStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyCachedUser = 'cached_user';

  Future<String?> getAccessToken() async => _storage.read(key: _keyAccessToken);

  Future<String?> getRefreshToken() async =>
      _storage.read(key: _keyRefreshToken);

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _storage.write(key: _keyAccessToken, value: accessToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _storage.write(key: _keyRefreshToken, value: refreshToken);
    }
  }

  Future<void> clearSession() async {
    await Future.wait([
      _storage.delete(key: _keyAccessToken),
      _storage.delete(key: _keyRefreshToken),
      _storage.delete(key: _keyCachedUser),
    ]);
  }

  Future<bool> hasValidSession() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<UserEntity?> getUser() async {
    final userJson = await _storage.read(key: _keyCachedUser);
    if (userJson == null) return null;

    try {
      final decoded = jsonDecode(userJson);
      if (decoded is! Map<String, dynamic>) return null;

      return UserEntity(
        id: decoded['id'] as int,
        displayName: decoded['displayName'] as String,
        username: decoded['username'] as String,
        email: decoded['email'] as String? ?? '',
        imageUrl: decoded['imageUrl'] as String?,
        isArtist: decoded['isArtist'] as bool? ?? false,
      );
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }

  Future<void> saveUser(UserEntity user) async {
    final userJson = jsonEncode({
      'id': user.id,
      'displayName': user.displayName,
      'username': user.username,
      'email': user.email,
      'imageUrl': user.imageUrl,
      'isArtist': user.isArtist,
    });
    await _storage.write(key: _keyCachedUser, value: userJson);
  }
}
