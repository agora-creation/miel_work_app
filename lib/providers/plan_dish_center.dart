import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/models/organization.dart';
import 'package:miel_work_app/models/plan_dish_center.dart';
import 'package:miel_work_app/models/plan_dish_center_week.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/log.dart';
import 'package:miel_work_app/services/plan_dish_center.dart';

class PlanDishCenterProvider with ChangeNotifier {
  final PlanDishCenterService _dishCenterService = PlanDishCenterService();
  final LogService _logService = LogService();

  Future<String?> create({
    required OrganizationModel? organization,
    required UserModel? user,
    required DateTime startedAt,
    required DateTime endedAt,
    required String remarks,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '勤務予定の追加に失敗しました';
    if (user == null) return '勤務予定の追加に失敗しました';
    if (loginUser == null) return '勤務予定の追加に失敗しました';
    try {
      String id = _dishCenterService.id();
      _dishCenterService.create({
        'id': id,
        'organizationId': organization.id,
        'userId': user.id,
        'userName': user.name,
        'startedAt': startedAt,
        'endedAt': endedAt,
        'remarks': remarks,
        'createdAt': DateTime.now(),
        'expirationAt': startedAt.add(const Duration(days: 365)),
      });
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': organization.id,
        'content': '食器センターの勤務予定を追加しました。',
        'device': 'SP(アプリ)',
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '勤務予定の追加に失敗しました';
    }
    return error;
  }

  Future<String?> createWeeks({
    required OrganizationModel? organization,
    required List<PlanDishCenterWeekModel> dishCenterWeeks,
    required List<DateTime> days,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '1ヵ月分の反映に失敗しました';
    if (dishCenterWeeks.isEmpty) return '1ヵ月分の反映に失敗しました';
    if (days.isEmpty) return '1ヵ月分の反映に失敗しました';
    if (loginUser == null) return '1ヵ月分の反映に失敗しました';
    try {
      for (final day in days) {
        String week = dateText('E', day);
        for (final dishCenterWeek in dishCenterWeeks) {
          if (dishCenterWeek.week == week) {
            String id = _dishCenterService.id();
            DateTime startedAt = DateTime(
              day.year,
              day.month,
              day.day,
              int.parse(dishCenterWeek.startedTime.split(':')[0]),
              int.parse(dishCenterWeek.startedTime.split(':')[1]),
            );
            DateTime endedAt = DateTime(
              day.year,
              day.month,
              day.day,
              int.parse(dishCenterWeek.endedTime.split(':')[0]),
              int.parse(dishCenterWeek.endedTime.split(':')[1]),
            );
            _dishCenterService.create({
              'id': id,
              'organizationId': organization.id,
              'userId': dishCenterWeek.userId,
              'userName': dishCenterWeek.userName,
              'startedAt': startedAt,
              'endedAt': endedAt,
              'remarks': '',
              'createdAt': DateTime.now(),
              'expirationAt': startedAt.add(const Duration(days: 365)),
            });
          }
        }
      }
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': organization.id,
        'content': '食器センターの勤務予定に1ヵ月分を反映しました。',
        'device': 'SP(アプリ)',
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '1ヵ月分の反映に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required PlanDishCenterModel dishCenter,
    required OrganizationModel? organization,
    required UserModel? user,
    required DateTime startedAt,
    required DateTime endedAt,
    required String remarks,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '勤務予定の編集に失敗しました';
    if (user == null) return '勤務予定の編集に失敗しました';
    if (loginUser == null) return '勤務予定の編集に失敗しました';
    try {
      _dishCenterService.update({
        'id': dishCenter.id,
        'organizationId': organization.id,
        'userId': user.id,
        'userName': user.name,
        'startedAt': startedAt,
        'endedAt': endedAt,
        'remarks': remarks,
        'expirationAt': startedAt.add(const Duration(days: 365)),
      });
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': organization.id,
        'content': '食器センターの勤務予定を編集しました。',
        'device': 'SP(アプリ)',
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '勤務予定の編集に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required PlanDishCenterModel dishCenter,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '勤務予定の削除に失敗しました';
    try {
      _dishCenterService.delete({
        'id': dishCenter.id,
      });
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': dishCenter.organizationId,
        'content': '食器センターの勤務予定を削除しました。',
        'device': 'SP(アプリ)',
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '勤務予定の削除に失敗しました';
    }
    return error;
  }
}
