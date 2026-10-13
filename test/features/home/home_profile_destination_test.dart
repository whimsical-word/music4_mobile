import 'package:flutter_test/flutter_test.dart';
import 'package:music4_mobile/core/router/route_names.dart';
import 'package:music4_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_state.dart';
import 'package:music4_mobile/features/home/presentation/utils/profile_destination.dart';

AuthAuthenticated _user({required int id, required bool isArtist}) {
  return AuthAuthenticated(
    UserEntity(
      id: id,
      displayName: 'Name $id',
      username: 'user$id',
      isArtist: isArtist,
    ),
  );
}

void main() {
  group('[CE190284] Home profile icon destination', () {
    test('an artist account opens their own Artist Profile', () {
      expect(profileRouteFor(_user(id: 3, isArtist: true)), '/artist/3');
    });

    test('a listener opens the listener profile', () {
      expect(
        profileRouteFor(_user(id: 5, isArtist: false)),
        RouteNames.userProfile,
      );
    });

    test('a guest opens the listener profile screen', () {
      expect(
        profileRouteFor(const AuthUnauthenticated()),
        RouteNames.userProfile,
      );
    });
  });
}
