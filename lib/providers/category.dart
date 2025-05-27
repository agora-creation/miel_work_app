import 'package:flutter/material.dart';
import 'package:miel_work_app/models/category.dart';
import 'package:miel_work_app/models/organization.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/category.dart';
import 'package:miel_work_app/services/log.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  final LogService _logService = LogService();

  Future<String?> create({
    required OrganizationModel? organization,
    required String name,
    required Color color,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return 'カテゴリの追加に失敗しました';
    if (name == '') return 'カテゴリ名は必須入力です';
    if (loginUser == null) return 'カテゴリの追加に失敗しました';
    try {
      String id = _categoryService.id();
      _categoryService.create({
        'id': id,
        'organizationId': organization.id,
        'name': name,
        'color': color.value.toRadixString(16),
        'createdAt': DateTime.now(),
      });
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': organization.id,
        'content': 'カテゴリを追加しました。',
        'device': 'SP(アプリ)',
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = 'カテゴリの追加に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required CategoryModel category,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return 'カテゴリの削除に失敗しました';
    try {
      _categoryService.delete({
        'id': category.id,
      });
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': category.organizationId,
        'content': 'カテゴリを削除しました。',
        'device': 'SP(アプリ)',
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = 'カテゴリの削除に失敗しました';
    }
    return error;
  }
}
