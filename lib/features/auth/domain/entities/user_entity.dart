class UserEntity {
  final int id;
  final String displayName;
  final String username;
  final String? imageUrl;
  final String email;
  final bool isArtist;

  const UserEntity({
    required this.id,
    this.email = '',
    required this.displayName,
    required this.username,
    this.imageUrl,
    required this.isArtist,
  });

  UserEntity copyWith({
    int? id,
    String? displayName,
    String? username,
    String? imageUrl,
    String? email,
    bool? isArtist,
  }) {
    return UserEntity(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      username: username ?? this.username,
      imageUrl: imageUrl ?? this.imageUrl,
      email: email ?? this.email,
      isArtist: isArtist ?? this.isArtist,
    );
  }
}

sealed class Failure {
  final String message;
  const Failure(this.message);
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
