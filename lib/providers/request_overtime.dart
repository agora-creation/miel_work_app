import 'package:flutter/material.dart';
import 'package:miel_work_app/models/approval_user.dart';
import 'package:miel_work_app/models/request_overtime.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/mail.dart';
import 'package:miel_work_app/services/request_overtime.dart';

class RequestOvertimeProvider with ChangeNotifier {
  final RequestOvertimeService _overtimeService = RequestOvertimeService();
  final MailService _mailService = MailService();

  Future<String?> approval({
    required RequestOvertimeModel overtime,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '申請の承認に失敗しました';
    try {
      List<Map> approvalUsers = [];
      if (overtime.approvalUsers.isNotEmpty) {
        for (ApprovalUserModel approvalUser in overtime.approvalUsers) {
          approvalUsers.add(approvalUser.toMap());
        }
      }
      approvalUsers.add({
        'userId': loginUser.id,
        'userName': loginUser.name,
        'userPresident': loginUser.president,
        'approvedAt': DateTime.now(),
      });
      _overtimeService.update({
        'id': overtime.id,
        'approval': 1,
        'approvedAt': DateTime.now(),
        'approvalUsers': approvalUsers,
      });
      String message = '''
夜間居残り作業申請が承認されました。

      ''';
      _mailService.create({
        'id': _mailService.id(),
        'to': overtime.companyUserEmail,
        'subject': '夜間居残り作業申請承認のお知らせ',
        'message': message,
        'createdAt': DateTime.now(),
        'expirationAt': DateTime.now().add(const Duration(hours: 1)),
      });
    } catch (e) {
      error = '申請の承認に失敗しました';
    }
    return error;
  }

  Future<String?> reject({
    required RequestOvertimeModel overtime,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '申請の否決に失敗しました';
    try {
      _overtimeService.update({
        'id': overtime.id,
        'approval': 9,
      });
      String message = '''
夜間居残り作業申請が否決されました。

      ''';
      _mailService.create({
        'id': _mailService.id(),
        'to': overtime.companyUserEmail,
        'subject': '夜間居残り作業申請否決のお知らせ',
        'message': message,
        'createdAt': DateTime.now(),
        'expirationAt': DateTime.now().add(const Duration(hours: 1)),
      });
    } catch (e) {
      error = '申請の否決に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required RequestOvertimeModel overtime,
  }) async {
    String? error;
    try {
      _overtimeService.delete({
        'id': overtime.id,
      });
    } catch (e) {
      error = '申請情報の削除に失敗しました';
    }
    return error;
  }
}
