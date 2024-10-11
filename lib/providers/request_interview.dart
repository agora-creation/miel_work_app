import 'package:flutter/material.dart';
import 'package:miel_work_app/models/approval_user.dart';
import 'package:miel_work_app/models/request_interview.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/request_interview.dart';

class RequestInterviewProvider with ChangeNotifier {
  final RequestInterviewService _interviewService = RequestInterviewService();

  Future<String?> approval({
    required RequestInterviewModel interview,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '申請の承認に失敗しました';
    try {
      List<Map> approvalUsers = [];
      if (interview.approvalUsers.isNotEmpty) {
        for (ApprovalUserModel approvalUser in interview.approvalUsers) {
          approvalUsers.add(approvalUser.toMap());
        }
      }
      approvalUsers.add({
        'userId': loginUser.id,
        'userName': loginUser.name,
        'userPresident': loginUser.president,
        'approvedAt': DateTime.now(),
      });
      if (loginUser.president) {
        _interviewService.update({
          'id': interview.id,
          'approval': 1,
          'approvedAt': DateTime.now(),
          'approvalUsers': approvalUsers,
        });
      } else {
        _interviewService.update({
          'id': interview.id,
          'approvalUsers': approvalUsers,
        });
      }
    } catch (e) {
      error = '申請の承認に失敗しました';
    }
    return error;
  }

  Future<String?> reject({
    required RequestInterviewModel interview,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '申請の否決に失敗しました';
    try {
      _interviewService.update({
        'id': interview.id,
        'approval': 9,
      });
    } catch (e) {
      error = '申請の否決に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required RequestInterviewModel interview,
  }) async {
    String? error;
    try {
      _interviewService.delete({
        'id': interview.id,
      });
    } catch (e) {
      error = '申請情報の削除に失敗しました';
    }
    return error;
  }
}
