import 'package:flutter/material.dart';
import 'package:miel_work_app/models/organization.dart';
import 'package:miel_work_app/models/report.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/report.dart';

class ReportProvider with ChangeNotifier {
  final ReportService _reportService = ReportService();

  Future<String?> create({
    required OrganizationModel? organization,
    required DateTime createdAt,
    required String workUser1Name,
    required String workUser1Time,
    required String workUser2Name,
    required String workUser2Time,
    required String workUser3Name,
    required String workUser3Time,
    required String workUser4Name,
    required String workUser4Time,
    required String workUser5Name,
    required String workUser5Time,
    required String workUser6Name,
    required String workUser6Time,
    required String workUser7Name,
    required String workUser7Time,
    required String workUser8Name,
    required String workUser8Time,
    required String workUser9Name,
    required String workUser9Time,
    required String workUser10Name,
    required String workUser10Time,
    required String workUser11Name,
    required String workUser11Time,
    required String workUser12Name,
    required String workUser12Time,
    required String workUser13Name,
    required String workUser13Time,
    required String workUser14Name,
    required String workUser14Time,
    required String workUser15Name,
    required String workUser15Time,
    required String workUser16Name,
    required String workUser16Time,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '日報の保存に失敗しました';
    if (loginUser == null) return '日報の保存に失敗しました';
    try {
      String id = _reportService.id();
      _reportService.create({
        'id': id,
        'organizationId': organization.id,
        'workUser1Name': workUser1Name,
        'workUser1Time': workUser1Time,
        'workUser2Name': workUser2Name,
        'workUser2Time': workUser2Time,
        'workUser3Name': workUser3Name,
        'workUser3Time': workUser3Time,
        'workUser4Name': workUser4Name,
        'workUser4Time': workUser4Time,
        'workUser5Name': workUser5Name,
        'workUser5Time': workUser5Time,
        'workUser6Name': workUser6Name,
        'workUser6Time': workUser6Time,
        'workUser7Name': workUser7Name,
        'workUser7Time': workUser7Time,
        'workUser8Name': workUser8Name,
        'workUser8Time': workUser8Time,
        'workUser9Name': workUser9Name,
        'workUser9Time': workUser9Time,
        'workUser10Name': workUser10Name,
        'workUser10Time': workUser10Time,
        'workUser11Name': workUser11Name,
        'workUser11Time': workUser11Time,
        'workUser12Name': workUser12Name,
        'workUser12Time': workUser12Time,
        'workUser13Name': workUser13Name,
        'workUser13Time': workUser13Time,
        'workUser14Name': workUser14Name,
        'workUser14Time': workUser14Time,
        'workUser15Name': workUser15Name,
        'workUser15Time': workUser15Time,
        'workUser16Name': workUser16Name,
        'workUser16Time': workUser16Time,
        'approval': 0,
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': createdAt,
        'expirationAt': createdAt.add(const Duration(days: 365)),
      });
    } catch (e) {
      error = '日報の保存に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required ReportModel report,
    required String workUser1Name,
    required String workUser1Time,
    required String workUser2Name,
    required String workUser2Time,
    required String workUser3Name,
    required String workUser3Time,
    required String workUser4Name,
    required String workUser4Time,
    required String workUser5Name,
    required String workUser5Time,
    required String workUser6Name,
    required String workUser6Time,
    required String workUser7Name,
    required String workUser7Time,
    required String workUser8Name,
    required String workUser8Time,
    required String workUser9Name,
    required String workUser9Time,
    required String workUser10Name,
    required String workUser10Time,
    required String workUser11Name,
    required String workUser11Time,
    required String workUser12Name,
    required String workUser12Time,
    required String workUser13Name,
    required String workUser13Time,
    required String workUser14Name,
    required String workUser14Time,
    required String workUser15Name,
    required String workUser15Time,
    required String workUser16Name,
    required String workUser16Time,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '日報の保存に失敗しました';
    try {
      _reportService.update({
        'id': report.id,
        'workUser1Name': workUser1Name,
        'workUser1Time': workUser1Time,
        'workUser2Name': workUser2Name,
        'workUser2Time': workUser2Time,
        'workUser3Name': workUser3Name,
        'workUser3Time': workUser3Time,
        'workUser4Name': workUser4Name,
        'workUser4Time': workUser4Time,
        'workUser5Name': workUser5Name,
        'workUser5Time': workUser5Time,
        'workUser6Name': workUser6Name,
        'workUser6Time': workUser6Time,
        'workUser7Name': workUser7Name,
        'workUser7Time': workUser7Time,
        'workUser8Name': workUser8Name,
        'workUser8Time': workUser8Time,
        'workUser9Name': workUser9Name,
        'workUser9Time': workUser9Time,
        'workUser10Name': workUser10Name,
        'workUser10Time': workUser10Time,
        'workUser11Name': workUser11Name,
        'workUser11Time': workUser11Time,
        'workUser12Name': workUser12Name,
        'workUser12Time': workUser12Time,
        'workUser13Name': workUser13Name,
        'workUser13Time': workUser13Time,
        'workUser14Name': workUser14Name,
        'workUser14Time': workUser14Time,
        'workUser15Name': workUser15Name,
        'workUser15Time': workUser15Time,
        'workUser16Name': workUser16Name,
        'workUser16Time': workUser16Time,
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
      });
    } catch (e) {
      error = '日報の保存に失敗しました';
    }
    return error;
  }

  Future<String?> approval({
    required ReportModel report,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '日報の承認に失敗しました';
    try {
      _reportService.update({
        'id': report.id,
        'approval': 1,
      });
    } catch (e) {
      error = '日報の承認に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required ReportModel report,
  }) async {
    String? error;
    try {
      _reportService.delete({
        'id': report.id,
      });
    } catch (e) {
      error = '日報の削除に失敗しました';
    }
    return error;
  }
}
