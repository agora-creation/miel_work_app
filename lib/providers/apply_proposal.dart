import 'package:flutter/material.dart';
import 'package:miel_work_app/models/apply_proposal.dart';
import 'package:miel_work_app/models/approval_user.dart';
import 'package:miel_work_app/models/organization.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/apply_proposal.dart';

class ApplyProposalProvider with ChangeNotifier {
  final ApplyProposalService _proposalService = ApplyProposalService();

  Future<String?> create({
    required OrganizationModel? organization,
    required OrganizationGroupModel? group,
    required String title,
    required String content,
    required int price,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '稟議申請に失敗しました';
    if (title == '') return '件名を入力してください';
    if (content == '') return '内容を入力してください';
    if (loginUser == null) return '稟議申請に失敗しました';
    try {
      String id = _proposalService.id();
      _proposalService.create({
        'id': id,
        'organizationId': organization.id,
        'groupId': group?.id ?? '',
        'title': title,
        'content': content,
        'price': price,
        'approval': false,
        'approvedAt': DateTime.now(),
        'approvalUsers': [],
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '稟議申請に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required ApplyProposalModel proposal,
    required bool approval,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '承認に失敗しました';
    try {
      List<Map> approvalUsers = [];
      if (proposal.approvalUsers.isNotEmpty) {
        for (ApprovalUserModel approvalUser in proposal.approvalUsers) {
          approvalUsers.add(approvalUser.toMap());
        }
      }
      approvalUsers.add({
        'userId': loginUser.id,
        'userName': loginUser.name,
        'approvedAt': DateTime.now(),
      });
      if (approval) {
        _proposalService.update({
          'id': proposal.id,
          'approval': approval,
          'approvedAt': DateTime.now(),
          'approvalUsers': approvalUsers,
        });
      } else {
        _proposalService.update({
          'id': proposal.id,
          'approval': approval,
          'approvalUsers': approvalUsers,
        });
      }
    } catch (e) {
      error = '承認に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required ApplyProposalModel proposal,
  }) async {
    String? error;
    try {
      _proposalService.delete({
        'id': proposal.id,
      });
    } catch (e) {
      error = '稟議申請の削除に失敗しました';
    }
    return error;
  }
}
