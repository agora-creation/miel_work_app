import 'package:flutter/material.dart';
import 'package:miel_work_app/models/approval_user.dart';
import 'package:miel_work_app/models/request_cycle.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/mail.dart';
import 'package:miel_work_app/services/request_cycle.dart';

class RequestCycleProvider with ChangeNotifier {
  final RequestCycleService _cycleService = RequestCycleService();
  final MailService _mailService = MailService();

  Future<String?> update({
    required RequestCycleModel cycle,
    required String companyName,
    required String companyUserName,
    required String companyUserEmail,
    required String companyUserTel,
    required String companyAddress,
  }) async {
    String? error;
    try {
      _cycleService.update({
        'id': cycle.id,
        'companyName': companyName,
        'companyUserName': companyUserName,
        'companyUserEmail': companyUserEmail,
        'companyUserTel': companyUserTel,
        'companyAddress': companyAddress,
      });
    } catch (e) {
      error = '自転車置き場使用申込情報の編集に失敗しました';
    }
    return error;
  }

  Future<String?> approval({
    required RequestCycleModel cycle,
    required String lockNumber,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (lockNumber == '') return '施錠番号を入力してください';
    if (loginUser == null) return '申請の承認に失敗しました';
    try {
      List<Map> approvalUsers = [];
      if (cycle.approvalUsers.isNotEmpty) {
        for (ApprovalUserModel approvalUser in cycle.approvalUsers) {
          approvalUsers.add(approvalUser.toMap());
        }
      }
      approvalUsers.add({
        'userId': loginUser.id,
        'userName': loginUser.name,
        'userPresident': loginUser.president,
        'approvedAt': DateTime.now(),
      });
      _cycleService.update({
        'id': cycle.id,
        'lockNumber': lockNumber,
        'approval': 1,
        'approvedAt': DateTime.now(),
        'approvalUsers': approvalUsers,
      });
      String message = '''
自転車置き場使用申込が承認されました。

施錠番号は『$lockNumber』です。

以下申込内容をご確認し、ご利用ください。
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
■申込者情報
【店舗名】${cycle.companyName}
【使用者名】${cycle.companyUserName}
【使用者メールアドレス】${cycle.companyUserEmail}
【使用者電話番号】${cycle.companyUserTel}
【住所】${cycle.companyAddress}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ''';
      _mailService.create({
        'id': _mailService.id(),
        'to': cycle.companyUserEmail,
        'subject': '自転車置き場使用申込承認のお知らせ',
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
    required RequestCycleModel cycle,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '申請の否決に失敗しました';
    try {
      _cycleService.update({
        'id': cycle.id,
        'approval': 9,
      });
      String message = '''
自転車置き場使用申込が否決されました。
以下申込内容をご確認し、再度申込を行なってください。
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
■申込者情報
【店舗名】${cycle.companyName}
【使用者名】${cycle.companyUserName}
【使用者メールアドレス】${cycle.companyUserEmail}
【使用者電話番号】${cycle.companyUserTel}
【住所】${cycle.companyAddress}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ''';
      _mailService.create({
        'id': _mailService.id(),
        'to': cycle.companyUserEmail,
        'subject': '自転車置き場使用申込否決のお知らせ',
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
    required RequestCycleModel cycle,
  }) async {
    String? error;
    try {
      _cycleService.delete({
        'id': cycle.id,
      });
    } catch (e) {
      error = '申請情報の削除に失敗しました';
    }
    return error;
  }
}
