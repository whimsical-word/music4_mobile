import 'dart:convert';

class JwtHelper {
  JwtHelper._();

  /// Giải mã payload của JWT Token không cần secret key
  static Map<String, dynamic>? decode(String? token) {
    if (token == null || token.isEmpty) return null;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Lấy user ID từ claim 'id' của JWT
  static int? getUserId(String? token) {
    final payload = decode(token);
    if (payload == null) return null;
    final id = payload['id'];
    if (id is int) return id;
    if (id is String) return int.tryParse(id);
    return null;
  }

  /// Lấy tên hiển thị (Full name) từ claim 'name' của JWT
  static String? getUserName(String? token) {
    final payload = decode(token);
    return payload?['name'] as String?;
  }

  /// Lấy username (subject) từ JWT
  static String? getUsername(String? token) {
    final payload = decode(token);
    return payload?['sub'] as String?;
  }
}
