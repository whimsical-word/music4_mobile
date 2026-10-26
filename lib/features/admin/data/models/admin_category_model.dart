import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_category_model.freezed.dart';
part 'admin_category_model.g.dart';

@freezed
sealed class AdminCategoryModel with _$AdminCategoryModel {
  const factory AdminCategoryModel({
    required int id,
    required String name,
    int? trackCount,
  }) = _AdminCategoryModel;

  factory AdminCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$AdminCategoryModelFromJson(json);
}
