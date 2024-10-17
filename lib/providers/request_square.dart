import 'package:flutter/material.dart';
import 'package:miel_work_app/models/approval_user.dart';
import 'package:miel_work_app/models/request_square.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/mail.dart';
import 'package:miel_work_app/services/request_square.dart';

class RequestSquareProvider with ChangeNotifier {
  final RequestSquareService _squareService = RequestSquareService();
  final MailService _mailService = MailService();

  Future<String?> approval({
    required RequestSquareModel square,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '申請の承認に失敗しました';
    try {
      List<Map> approvalUsers = [];
      if (square.approvalUsers.isNotEmpty) {
        for (ApprovalUserModel approvalUser in square.approvalUsers) {
          approvalUsers.add(approvalUser.toMap());
        }
      }
      approvalUsers.add({
        'userId': loginUser.id,
        'userName': loginUser.name,
        'userPresident': loginUser.president,
        'approvedAt': DateTime.now(),
      });
      _squareService.update({
        'id': square.id,
        'approval': 1,
        'approvedAt': DateTime.now(),
        'approvalUsers': approvalUsers,
      });
      String message = '''
よさこい広場使用申込が承認されました。

      ''';
      _mailService.create({
        'id': _mailService.id(),
        'to': square.companyUserEmail,
        'subject': 'よさこい広場使用申込承認のお知らせ',
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
    required RequestSquareModel square,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '申請の否決に失敗しました';
    try {
      _squareService.update({
        'id': square.id,
        'approval': 9,
      });
      String message = '''
よさこい広場使用申込が否決されました。

      ''';
      _mailService.create({
        'id': _mailService.id(),
        'to': square.companyUserEmail,
        'subject': 'よさこい広場使用申込否決のお知らせ',
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
    required RequestSquareModel square,
  }) async {
    String? error;
    try {
      _squareService.delete({
        'id': square.id,
      });
    } catch (e) {
      error = '申請情報の削除に失敗しました';
    }
    return error;
  }
}
