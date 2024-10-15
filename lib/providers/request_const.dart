import 'package:flutter/material.dart';
import 'package:miel_work_app/models/approval_user.dart';
import 'package:miel_work_app/models/request_const.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/request_const.dart';

class RequestConstProvider with ChangeNotifier {
  final RequestConstService _constService = RequestConstService();

  Future<String?> approval({
    required RequestConstModel requestConst,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '申請の承認に失敗しました';
    try {
      List<Map> approvalUsers = [];
      if (requestConst.approvalUsers.isNotEmpty) {
        for (ApprovalUserModel approvalUser in requestConst.approvalUsers) {
          approvalUsers.add(approvalUser.toMap());
        }
      }
      approvalUsers.add({
        'userId': loginUser.id,
        'userName': loginUser.name,
        'userPresident': loginUser.president,
        'approvedAt': DateTime.now(),
      });
      _constService.update({
        'id': requestConst.id,
        'approval': 1,
        'approvedAt': DateTime.now(),
        'approvalUsers': approvalUsers,
      });
    } catch (e) {
      error = '申請の承認に失敗しました';
    }
    return error;
  }

  Future<String?> reject({
    required RequestConstModel requestConst,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '申請の否決に失敗しました';
    try {
      _constService.update({
        'id': requestConst.id,
        'approval': 9,
      });
    } catch (e) {
      error = '申請の否決に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required RequestConstModel requestConst,
  }) async {
    String? error;
    try {
      _constService.delete({
        'id': requestConst.id,
      });
    } catch (e) {
      error = '申請情報の削除に失敗しました';
    }
    return error;
  }
}
