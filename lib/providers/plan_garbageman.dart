import 'package:flutter/material.dart';
import 'package:miel_work_app/models/organization.dart';
import 'package:miel_work_app/models/plan_garbageman.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/plan_garbageman.dart';

class PlanGarbagemanProvider with ChangeNotifier {
  final PlanGarbagemanService _garbagemanService = PlanGarbagemanService();

  Future<String?> create({
    required OrganizationModel? organization,
    required UserModel? user,
    required DateTime startedAt,
    required DateTime endedAt,
  }) async {
    String? error;
    if (organization == null) return '勤務予定の追加に失敗しました';
    if (user == null) return '勤務予定の追加に失敗しました';
    try {
      String id = _garbagemanService.id();
      _garbagemanService.create({
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
      error = '勤務予定の追加に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required PlanGarbagemanModel garbageman,
    required OrganizationModel? organization,
    required UserModel? user,
    required DateTime startedAt,
    required DateTime endedAt,
  }) async {
    String? error;
    if (organization == null) return '勤務予定の編集に失敗しました';
    if (user == null) return '勤務予定の編集に失敗しました';
    try {
      _garbagemanService.update({
        'id': garbageman.id,
        'organizationId': organization.id,
        'userId': user.id,
        'userName': user.name,
        'startedAt': startedAt,
        'endedAt': endedAt,
        'expirationAt': startedAt.add(const Duration(days: 365)),
      });
    } catch (e) {
      error = '勤務予定の編集に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required PlanGarbagemanModel garbageman,
  }) async {
    String? error;
    try {
      _garbagemanService.delete({
        'id': garbageman.id,
      });
    } catch (e) {
      error = '勤務予定の削除に失敗しました';
    }
    return error;
  }
}
