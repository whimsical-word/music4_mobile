/// Các ngoại lệ kỹ thuật thuộc tầng Data của feature Auth.
/// Được ném ra bởi RemoteDataSource và được Repository bắt để chuyển đổi
/// thành Domain Failure tương ứng.
class RequiresVerificationException implements Exception {
  final String email;
  final String? role;
  final String message;

  const RequiresVerificationException({
    required this.email,
    this.role,
    required this.message,
  });

  @override
  String toString() => message;
}
