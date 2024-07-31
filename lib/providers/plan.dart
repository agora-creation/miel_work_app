import 'package:flutter/material.dart';
import 'package:miel_work_app/models/category.dart';
import 'package:miel_work_app/models/organization.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/plan.dart';
import 'package:miel_work_app/services/plan.dart';

class PlanProvider with ChangeNotifier {
  final PlanService _planService = PlanService();

  Future<String?> create({
    required OrganizationModel? organization,
    required OrganizationGroupModel? group,
    required CategoryModel? category,
    required String subject,
    required DateTime startedAt,
    required DateTime endedAt,
    required bool allDay,
    required bool repeat,
    required String repeatInterval,
    required int repeatEvery,
    required List<String> repeatWeeks,
    required String memo,
    required int alertMinute,
  }) async {
    String? error;
    if (organization == null) return '予定の追加に失敗しました';
    if (category == null) return 'カテゴリは必須選択です';
    if (subject == '') return '件名は必須入力です';
    if (startedAt.millisecondsSinceEpoch > endedAt.millisecondsSinceEpoch) {
      return '日時を正しく選択してください';
    }
    try {
      List<String> userIds = [];
      if (group != null) {
        userIds = group.userIds;
      } else {
        userIds = organization.userIds;
      }
      String id = _planService.id();
      _planService.create({
        'id': id,
        'organizationId': organization.id,
        'groupId': group?.id ?? '',
        'userIds': userIds,
        'category': category.name,
        'categoryColor': category.color.value.toRadixString(16),
        'subject': subject,
        'startedAt': startedAt,
        'endedAt': endedAt,
        'allDay': allDay,
        'repeat': repeat,
        'repeatInterval': repeatInterval,
        'repeatEvery': repeatEvery,
        'repeatWeeks': repeatWeeks,
        'memo': memo,
        'alertMinute': alertMinute,
        'alertedAt': startedAt.subtract(Duration(minutes: alertMinute)),
        'createdAt': DateTime.now(),
        'expirationAt': startedAt.add(const Duration(days: 365)),
      });
    } catch (e) {
      error = '予定の追加に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required PlanModel plan,
    required OrganizationModel? organization,
    required OrganizationGroupModel? group,
    required CategoryModel? category,
    required String subject,
    required DateTime startedAt,
    required DateTime endedAt,
    required bool allDay,
    required bool repeat,
    required String repeatInterval,
    required int repeatEvery,
    required List<String> repeatWeeks,
    required String memo,
    required int alertMinute,
  }) async {
    String? error;
    if (organization == null) return '予定の編集に失敗しました';
    if (category == null) return 'カテゴリは必須選択です';
    if (subject == '') return '件名は必須入力です';
    if (startedAt.millisecondsSinceEpoch > endedAt.millisecondsSinceEpoch) {
      return '日時を正しく選択してください';
    }
    try {
      List<String> userIds = [];
      if (group != null) {
        userIds = group.userIds;
      } else {
        userIds = organization.userIds;
      }
      _planService.update({
        'id': plan.id,
        'organizationId': organization.id,
        'groupId': group?.id ?? '',
        'userIds': userIds,
        'category': category.name,
        'categoryColor': category.color.value.toRadixString(16),
        'subject': subject,
        'startedAt': startedAt,
        'endedAt': endedAt,
        'allDay': allDay,
        'repeat': repeat,
        'repeatInterval': repeatInterval,
        'repeatEvery': repeatEvery,
        'repeatWeeks': repeatWeeks,
        'memo': memo,
        'alertMinute': alertMinute,
        'alertedAt': startedAt.subtract(Duration(minutes: alertMinute)),
        'expirationAt': startedAt.add(const Duration(days: 365)),
      });
    } catch (e) {
      error = '予定の編集に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required PlanModel plan,
  }) async {
    String? error;
    try {
      _planService.delete({
        'id': plan.id,
      });
    } catch (e) {
      error = '予定の削除に失敗しました';
    }
    return error;
  }
}
