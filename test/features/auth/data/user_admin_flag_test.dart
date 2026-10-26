import 'package:flutter_test/flutter_test.dart';
import 'package:music4_mobile/features/auth/data/models/auth_response_model.dart';
import 'package:music4_mobile/features/auth/domain/entities/user_entity.dart';

AuthResponseModel login(String role) => AuthResponseModel.fromJson({
  'accessToken': 'a',
  'refreshToken': 'r',
  'id': 1,
  'username': 'someone',
  'name': 'Someone',
  'img': null,
  'role': role,
});

void main() {
  group('[CE190284] the admin flag of a signed-in user', () {
    test('ROLE_ADMIN is an admin and not an artist', () {
      final user = login('ROLE_ADMIN').toEntity();

      expect(user.isAdmin, isTrue);
      expect(user.isArtist, isFalse);
    });

    test('ROLE_ARTIST and ROLE_LISTENER are not admins', () {
      expect(login('ROLE_ARTIST').toEntity().isAdmin, isFalse);
      expect(login('ROLE_LISTENER').toEntity().isAdmin, isFalse);
      expect(login('').toEntity().isAdmin, isFalse);
    });

    test('a UserEntity built the old way is not an admin', () {
      const user = UserEntity(
        id: 1,
        displayName: 'Old',
        username: 'old',
        isArtist: false,
      );

      expect(user.isAdmin, isFalse);
    });

    test('copyWith keeps the flag unless it is changed', () {
      const admin = UserEntity(
        id: 1,
        displayName: 'Admin',
        username: 'admin',
        isArtist: false,
        isAdmin: true,
      );

      expect(admin.copyWith(displayName: 'Renamed').isAdmin, isTrue);
      expect(admin.copyWith(isAdmin: false).isAdmin, isFalse);
    });
  });
}
