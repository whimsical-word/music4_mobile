import 'package:freezed_annotation/freezed_annotation.dart';
import 'admin_user_model.dart';

part 'admin_user_page_model.freezed.dart';
part 'admin_user_page_model.g.dart';

@freezed
sealed class AdminUserPageModel with _$AdminUserPageModel {
  const factory AdminUserPageModel({
    @Default([]) List<AdminUserModel> content,
    @Default(0) int pageNumber,
    @Default(20) int size,
    @Default(0) int totalElements,
    @Default(0) int totalPages,
    @Default(true) bool last,
  }) = _AdminUserPageModel;

  factory AdminUserPageModel.fromJson(Map<String, dynamic> json) =>
      _$AdminUserPageModelFromJson(json);
}
