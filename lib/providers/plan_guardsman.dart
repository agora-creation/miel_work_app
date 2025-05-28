import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/models/organization.dart';
import 'package:miel_work_app/models/plan_guardsman.dart';
import 'package:miel_work_app/models/plan_guardsman_week.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/log.dart';
import 'package:miel_work_app/services/plan_guardsman.dart';

class PlanGuardsmanProvider with ChangeNotifier {
  final PlanGuardsmanService _guardsmanService = PlanGuardsmanService();
  final LogService _logService = LogService();

  Future<String?> create({
    required OrganizationModel? organization,
    required DateTime startedAt,
    required DateTime endedAt,
    required String remarks,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '勤務予定の追加に失敗しました';
    if (loginUser == null) return '勤務予定の追加に失敗しました';
    try {
      String id = _guardsmanService.id();
      _guardsmanService.create({
        'id': id,
        'organizationId': organization.id,
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
        'content': '警備員の勤務予定を追加しました。',
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
    required List<PlanGuardsmanWeekModel> guardsmanWeeks,
    required List<DateTime> days,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '1ヵ月分の反映に失敗しました';
    if (guardsmanWeeks.isEmpty) return '1ヵ月分の反映に失敗しました';
    if (days.isEmpty) return '1ヵ月分の反映に失敗しました';
    if (loginUser == null) return '1ヵ月分の反映に失敗しました';
    try {
      for (final day in days) {
        String week = dateText('E', day);
        for (final guardsmanWeek in guardsmanWeeks) {
          if (guardsmanWeek.week == week) {
            String id = _guardsmanService.id();
            DateTime startedAt = DateTime(
              day.year,
              day.month,
              day.day,
              int.parse(guardsmanWeek.startedTime.split(':')[0]),
              int.parse(guardsmanWeek.startedTime.split(':')[1]),
            );
            DateTime endedAt = DateTime(
              day.year,
              day.month,
              day.day,
              int.parse(guardsmanWeek.endedTime.split(':')[0]),
              int.parse(guardsmanWeek.endedTime.split(':')[1]),
            );
            _guardsmanService.create({
              'id': id,
              'organizationId': organization.id,
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
        'content': '警備員の勤務予定に1ヵ月分を反映しました。',
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
    required PlanGuardsmanModel guardsman,
    required OrganizationModel? organization,
    required DateTime startedAt,
    required DateTime endedAt,
    required String remarks,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '勤務予定の編集に失敗しました';
    if (loginUser == null) return '勤務予定の編集に失敗しました';
    try {
      _guardsmanService.update({
        'id': guardsman.id,
        'organizationId': organization.id,
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
        'content': '警備員の勤務予定を編集しました。',
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
    required PlanGuardsmanModel guardsman,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '勤務予定の削除に失敗しました';
    try {
      _guardsmanService.delete({
        'id': guardsman.id,
      });
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': guardsman.organizationId,
        'content': '警備員の勤務予定を削除しました。',
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
