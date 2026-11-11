import 'package:music4_mobile/features/auth/domain/entities/user_entity.dart';

sealed class AuthState {
  const AuthState();
}

/// Trạng thái khởi đầu — chưa biết user có logged in không.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Đang gọi API login / kiểm tra session.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Đã xác thực thành công.
class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);
}

/// Chưa đăng nhập (hoặc đã logout).
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Yêu cầu xác thực OTP email sau khi login (tài khoản chưa active)
class AuthRequiresVerification extends AuthState {
  final String email;
  final String? role;
  final String message;

  const AuthRequiresVerification({
    required this.email,
    this.role,
    required this.message,
  });
}

/// Đăng nhập thất bại với thông báo lỗi.
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}
