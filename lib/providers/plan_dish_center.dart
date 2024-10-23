import 'package:flutter/material.dart';
import 'package:miel_work_app/models/organization.dart';
import 'package:miel_work_app/models/plan_dish_center.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/plan_dish_center.dart';

class PlanDishCenterProvider with ChangeNotifier {
  final PlanDishCenterService _dishCenterService = PlanDishCenterService();

  Future<String?> create({
    required OrganizationModel? organization,
    required UserModel? user,
    required DateTime startedAt,
    required DateTime endedAt,
  }) async {
    String? error;
    if (organization == null) return '食器センター予定の追加に失敗しました';
    if (user == null) return '食器センター予定の追加に失敗しました';
    try {
      String id = _dishCenterService.id();
      _dishCenterService.create({
        'id': id,
        'organizationId': organization.id,
        'userId': user.id,
        'userName': user.name,
        'startedAt': startedAt,
        'endedAt': endedAt,
        'createdAt': DateTime.now(),
        'expirationAt': startedAt.add(const Duration(days: 365)),
      });
    } catch (e) {
      error = '食器センター予定の追加に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required PlanDishCenterModel dishCenter,
    required OrganizationModel? organization,
    required UserModel? user,
    required DateTime startedAt,
    required DateTime endedAt,
  }) async {
    String? error;
    if (organization == null) return '食器センター予定の編集に失敗しました';
    if (user == null) return '食器センター予定の編集に失敗しました';
    try {
      _dishCenterService.update({
        'id': dishCenter.id,
        'organizationId': organization.id,
        'userId': user.id,
        'userName': user.name,
        'startedAt': startedAt,
        'endedAt': endedAt,
        'expirationAt': startedAt.add(const Duration(days: 365)),
      });
    } catch (e) {
      error = '食器センター予定の編集に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required PlanDishCenterModel dishCenter,
  }) async {
    String? error;
    try {
      _dishCenterService.delete({
        'id': dishCenter.id,
      });
    } catch (e) {
      error = '食器センター予定の削除に失敗しました';
    }
    return error;
  }
}
