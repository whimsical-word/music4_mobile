import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:music4_mobile/features/auth/domain/entities/user_entity.dart';

class TokenStorage {
  TokenStorage._();

  static final TokenStorage instance = TokenStorage._();

  final _storage = const FlutterSecureStorage();

  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  // static const _keyUserId = 'user_id';
  // static const _keyRole = 'role';

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  Future<void> saveToken({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _keyAccessToken, value: accessToken);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
  }

  Future<void> clear() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
  }

  Future<bool> hasValidSession() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<UserEntity?> getUser() async {
    final userJson = await _storage.read(key: 'cached_user');
    if (userJson == null) return null;

    final userMap = jsonDecode(userJson);
    return UserEntity(
      id: userMap['id'],
      displayName: userMap['displayName'],
      username: userMap['username'],
      isArtist: userMap['isArtist'],
    );
  }

  Future<void> saveUser(UserEntity user) async {
    final userJson = jsonEncode({
      'id': user.id,
      'displayName': user.displayName,
      'username': user.username,
      'isArtist': user.isArtist,
    });
    await _storage.write(key: 'cached_user', value: userJson);
  }
}
