class UserEntity {
  final int id;
  final String displayName;
  final String username;
  final String? imageUrl;
  final String email;
  final bool isArtist;
  final String role;

  /// `ROLE_ADMIN` accounts (the backend still enforces every admin API).
  final bool isAdmin;

  const UserEntity({
    required this.id,
    this.email = '',
    required this.displayName,
    required this.username,
    this.imageUrl,
    required this.isArtist,
    this.role = '',
    this.isAdmin = false,
  });

  UserEntity copyWith({
    int? id,
    String? displayName,
    String? username,
    String? imageUrl,
    String? email,
    bool? isArtist,
    String? role,
    bool? isAdmin,
  }) {
    final effectiveRole = role ?? this.role;
    return UserEntity(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      username: username ?? this.username,
      imageUrl: imageUrl ?? this.imageUrl,
      email: email ?? this.email,
      isArtist: isArtist ?? this.isArtist,
      role: effectiveRole,
      isAdmin: isAdmin ?? (role != null ? effectiveRole.contains('ADMIN') : this.isAdmin),
    );
  }
}

sealed class Failure {
  final String message;

  const Failure(this.message);
}

class GoogleSignInCancelledFailure extends Failure {
  const GoogleSignInCancelledFailure() : super('Đã huỷ đăng nhập Google');
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure() : super('Sai email hoặc mật khẩu');
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super('Không có kết nối mạng');
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Lỗi máy chủ, vui lòng thử lại']);
}

class RequiresEmailVerificationFailure extends Failure {
  final String email;
  final String? role;

  const RequiresEmailVerificationFailure({
    required this.email,
    this.role,
    String message =
        'Tài khoản chưa được kích hoạt. Mã OTP xác thực đã được gửi đến email của bạn.',
  }) : super(message);
}

sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);
}

class Error<T> extends Result<T> {
  final Failure failure;

  const Error(this.failure);
}
