import 'dart:io';

class RegisterRequest {
  final String name;
  final String email;
  final String username;
  final String password;
  final File? img;
  final String role; // 'artist' or 'listener'

  const RegisterRequest({
    required this.name,
    required this.email,
    required this.username,
    required this.password,
    this.img,
    required this.role,
  });
}
