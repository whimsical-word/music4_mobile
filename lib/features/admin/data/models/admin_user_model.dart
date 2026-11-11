import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_user_model.freezed.dart';
part 'admin_user_model.g.dart';

@freezed
sealed class AdminUserModel with _$AdminUserModel {
  const factory AdminUserModel({
    required int id,
    required String name,
    String? img,
    required String email,
    bool? gender,
    required String role,
    required String username,
    @Default(false) bool isDeleted,
    @Default(true) bool enabled,
  }) = _AdminUserModel;

  factory AdminUserModel.fromJson(Map<String, dynamic> json) =>
      _$AdminUserModelFromJson(json);
}
