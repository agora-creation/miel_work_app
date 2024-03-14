import 'package:flutter/material.dart';
import 'package:miel_work_app/models/apply_conference.dart';
import 'package:miel_work_app/models/approval_user.dart';
import 'package:miel_work_app/models/organization.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/apply_conference.dart';
import 'package:miel_work_app/services/fm.dart';
import 'package:miel_work_app/services/user.dart';

class ApplyConferenceProvider with ChangeNotifier {
  final ApplyConferenceService _conferenceService = ApplyConferenceService();
  final UserService _userService = UserService();
  final FmService _fmService = FmService();

  Future<String?> create({
    required OrganizationModel? organization,
    required OrganizationGroupModel? group,
    required String title,
    required String content,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '協議申請に失敗しました';
    if (title == '') return '件名を入力してください';
    if (content == '') return '内容を入力してください';
    if (loginUser == null) return '協議申請に失敗しました';
    try {
      String id = _conferenceService.id();
      _conferenceService.create({
        'id': id,
        'organizationId': organization.id,
        'groupId': group?.id ?? '',
        'title': title,
        'content': content,
        'approval': false,
        'approvedAt': DateTime.now(),
        'approvalUsers': [],
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
      //通知
      List<UserModel> sendUsers = [];
      sendUsers = await _userService.selectList(
        userIds: organization.userIds,
      );
      if (sendUsers.isNotEmpty) {
        for (UserModel user in sendUsers) {
          if (user.id == loginUser.id) continue;
          _fmService.send(
            token: user.token,
            title: title,
            body: '協議申請が提出されました。',
          );
        }
      }
    } catch (e) {
      error = '協議申請に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required ApplyConferenceModel conference,
    required bool approval,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '承認に失敗しました';
    try {
      List<Map> approvalUsers = [];
      if (conference.approvalUsers.isNotEmpty) {
        for (ApprovalUserModel approvalUser in conference.approvalUsers) {
          approvalUsers.add(approvalUser.toMap());
        }
      }
      approvalUsers.add({
        'userId': loginUser.id,
        'userName': loginUser.name,
        'approvedAt': DateTime.now(),
      });
      if (approval) {
        _conferenceService.update({
          'id': conference.id,
          'approval': approval,
          'approvedAt': DateTime.now(),
          'approvalUsers': approvalUsers,
        });
      } else {
        _conferenceService.update({
          'id': conference.id,
          'approval': approval,
          'approvalUsers': approvalUsers,
        });
      }
      //通知
      List<UserModel> sendUsers = [];
      sendUsers = await _userService.selectList(
        userIds: [conference.createdUserId],
      );
      if (sendUsers.isNotEmpty) {
        for (UserModel user in sendUsers) {
          if (user.id == loginUser.id) continue;
          _fmService.send(
            token: user.token,
            title: conference.title,
            body: '協議申請が承認されました。',
          );
        }
      }
    } catch (e) {
      error = '承認に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required ApplyConferenceModel conference,
  }) async {
    String? error;
    try {
      _conferenceService.delete({
        'id': conference.id,
      });
    } catch (e) {
      error = '協議申請の削除に失敗しました';
    }
    return error;
  }
}
