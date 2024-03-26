import 'package:flutter/material.dart';
import 'package:miel_work_app/models/category.dart';
import 'package:miel_work_app/models/organization.dart';
import 'package:miel_work_app/services/category.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService _categoryService = CategoryService();

  Future<String?> create({
    required OrganizationModel? organization,
    required String name,
    required Color color,
  }) async {
    String? error;
    if (organization == null) return 'カテゴリの追加に失敗しました';
    if (name == '') return 'カテゴリ名を入力してください';
    try {
      String id = _categoryService.id();
      _categoryService.create({
        'id': id,
        'organizationId': organization.id,
        'name': name,
        'color': color.value.toRadixString(16),
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = 'カテゴリの追加に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required CategoryModel category,
  }) async {
    String? error;
    try {
      _categoryService.delete({
        'id': category.id,
      });
    } catch (e) {
      error = 'カテゴリの削除に失敗しました';
    }
    return error;
  }
}
