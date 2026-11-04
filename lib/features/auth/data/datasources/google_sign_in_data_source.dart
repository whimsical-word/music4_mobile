import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:music4_mobile/core/constants/google_auth_config.dart';

abstract class GoogleSignInDataSource {
  /// Trả về idToken, hoặc null nếu người dùng huỷ.
  Future<String?> getIdToken();
  Future<void> signOut();
}

class GoogleSignInDataSourceImpl implements GoogleSignInDataSource {
  final GoogleSignIn _googleSignIn;
  GoogleSignInDataSourceImpl({GoogleSignIn? googleSignIn})
    : _googleSignIn =
          googleSignIn ??
          GoogleSignIn(
            scopes: const ['email', 'profile'],
            clientId: kIsWeb ? GoogleAuthConfig.serverClientId : null,
            serverClientId: kIsWeb ? null : GoogleAuthConfig.serverClientId,
          );
  @override
  Future<String?> getIdToken() async {
    final account = await _googleSignIn.signIn();
    if (account == null) return null;
    final auth = await account.authentication;
    return auth.idToken;
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // Không để lỗi sign-out Google chặn luồng logout của app.
    }
  }
}
