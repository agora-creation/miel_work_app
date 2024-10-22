import 'package:flutter/material.dart';
import 'package:miel_work_app/models/organization.dart';
import 'package:miel_work_app/models/plan_garbageman.dart';
import 'package:miel_work_app/services/plan_garbageman.dart';

class PlanGarbagemanProvider with ChangeNotifier {
  final PlanGarbagemanService _garbagemanService = PlanGarbagemanService();

  Future<String?> create({
    required OrganizationModel? organization,
    required String content,
    required DateTime eventAt,
  }) async {
    String? error;
    if (organization == null) return '清掃員予定の追加に失敗しました';
    if (content == '') return '内容は必須入力です';
    try {
      String id = _garbagemanService.id();
      _garbagemanService.create({
        'id': id,
        'organizationId': organization.id,
        'content': content,
        'eventAt': eventAt,
        'createdAt': DateTime.now(),
        'expirationAt': eventAt.add(const Duration(days: 365)),
      });
    } catch (e) {
      error = '清掃員予定の追加に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required PlanGarbagemanModel garbageman,
    required OrganizationModel? organization,
    required String content,
    required DateTime eventAt,
  }) async {
    String? error;
    if (organization == null) return '清掃員予定の編集に失敗しました';
    if (content == '') return '内容は必須入力です';
    try {
      _garbagemanService.update({
        'id': garbageman.id,
        'organizationId': organization.id,
        'content': content,
        'eventAt': eventAt,
        'expirationAt': eventAt.add(const Duration(days: 365)),
      });
    } catch (e) {
      error = '清掃員予定の編集に失敗しました';
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
      error = '清掃員予定の削除に失敗しました';
    }
    return error;
  }
}
