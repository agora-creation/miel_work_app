import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/models/approval_user.dart';
import 'package:miel_work_app/models/request_overtime.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/mail.dart';
import 'package:miel_work_app/services/request_overtime.dart';

class RequestOvertimeProvider with ChangeNotifier {
  final RequestOvertimeService _overtimeService = RequestOvertimeService();
  final MailService _mailService = MailService();

  Future<String?> update({
    required RequestOvertimeModel overtime,
    required String companyName,
    required String companyUserName,
    required String companyUserEmail,
    required String companyUserTel,
    required DateTime useStartedAt,
    required DateTime useEndedAt,
    required bool useAtPending,
    required String useContent,
  }) async {
    String? error;
    try {
      _overtimeService.update({
        'id': overtime.id,
        'companyName': companyName,
        'companyUserName': companyUserName,
        'companyUserEmail': companyUserEmail,
        'companyUserTel': companyUserTel,
        'useStartedAt': useStartedAt,
        'useEndedAt': useEndedAt,
        'useAtPending': useAtPending,
      });
    } catch (e) {
      error = '夜間居残り作業申請情報の編集に失敗しました';
    }
    return error;
  }

  Future<String?> addComment({
    required RequestOvertimeModel overtime,
    required String content,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (content == '') return '社内コメントの追記に失敗しました';
    if (loginUser == null) return '社内コメントの追記に失敗しました';
    try {
      List<Map> comments = [];
      if (overtime.comments.isNotEmpty) {
        for (final comment in overtime.comments) {
          comments.add(comment.toMap());
        }
      }
      comments.add({
        'id': dateText('yyyyMMddHHmm', DateTime.now()),
        'userId': loginUser.id,
        'userName': loginUser.name,
        'content': content,
        'createdAt': DateTime.now(),
      });
      _overtimeService.update({
        'id': overtime.id,
        'comments': comments,
      });
    } catch (e) {
      error = '社内コメントの追記に失敗しました';
    }
    return error;
  }

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
      String useAtText = '';
      if (overtime.useAtPending) {
        useAtText = '未定';
      } else {
        useAtText =
            '${dateText('yyyy/MM/dd HH:mm', overtime.useStartedAt)}〜${dateText('yyyy/MM/dd HH:mm', overtime.useEndedAt)}';
      }
      String attachedFilesText = '';
      if (overtime.attachedFiles.isNotEmpty) {
        for (final file in overtime.attachedFiles) {
          attachedFilesText += '$file\n';
        }
      }
      String message = '''
夜間居残り作業申請が承認されました。
以下申込内容をご確認し、作業を行なってください。
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
■申請者情報
【店舗名】${overtime.companyName}
【店舗責任者名】${overtime.companyUserName}
【店舗責任者メールアドレス】${overtime.companyUserEmail}
【店舗責任者電話番号】${overtime.companyUserTel}

■作業情報
【作業予定日時】$useAtText
【作業内容】
${overtime.useContent}

【添付ファイル】
$attachedFilesText

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
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
      String useAtText = '';
      if (overtime.useAtPending) {
        useAtText = '未定';
      } else {
        useAtText =
            '${dateText('yyyy/MM/dd HH:mm', overtime.useStartedAt)}〜${dateText('yyyy/MM/dd HH:mm', overtime.useEndedAt)}';
      }
      String attachedFilesText = '';
      if (overtime.attachedFiles.isNotEmpty) {
        for (final file in overtime.attachedFiles) {
          attachedFilesText += '$file\n';
        }
      }
      String message = '''
夜間居残り作業申請が否決されました。
以下申込内容をご確認し、再度申請を行なってください。
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
■申請者情報
【店舗名】${overtime.companyName}
【店舗責任者名】${overtime.companyUserName}
【店舗責任者メールアドレス】${overtime.companyUserEmail}
【店舗責任者電話番号】${overtime.companyUserTel}

■作業情報
【作業予定日時】$useAtText
【作業内容】
${overtime.useContent}

【添付ファイル】
$attachedFilesText

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
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
