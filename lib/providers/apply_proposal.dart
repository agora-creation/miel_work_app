import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/material.dart';
import 'package:miel_work_app/models/apply_proposal.dart';
import 'package:miel_work_app/models/approval_user.dart';
import 'package:miel_work_app/models/organization.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/apply_proposal.dart';
import 'package:miel_work_app/services/fm.dart';
import 'package:miel_work_app/services/user.dart';
import 'package:path/path.dart' as p;

class ApplyProposalProvider with ChangeNotifier {
  final ApplyProposalService _proposalService = ApplyProposalService();
  final UserService _userService = UserService();
  final FmService _fmService = FmService();

  Future<String?> create({
    required OrganizationModel? organization,
    required OrganizationGroupModel? group,
    required String title,
    required String content,
    required int price,
    required File? pickedFile,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '稟議申請に失敗しました';
    if (title == '') return '件名を入力してください';
    if (content == '') return '内容を入力してください';
    if (loginUser == null) return '稟議申請に失敗しました';
    try {
      String id = _proposalService.id();
      String file = '';
      String fileExt = '';
      if (pickedFile != null) {
        String ext = p.extension(pickedFile.path);
        storage.UploadTask uploadTask;
        storage.Reference ref = storage.FirebaseStorage.instance
            .ref()
            .child('applyProposal')
            .child('/$id$ext');
        uploadTask = ref.putData(pickedFile.readAsBytesSync());
        await uploadTask.whenComplete(() => null);
        file = await ref.getDownloadURL();
        fileExt = ext;
      }
      _proposalService.create({
        'id': id,
        'organizationId': organization.id,
        'groupId': group?.id ?? '',
        'title': title,
        'content': content,
        'price': price,
        'file': file,
        'fileExt': fileExt,
        'approval': 0,
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
            body: '稟議申請が提出されました。',
          );
        }
      }
    } catch (e) {
      error = '稟議申請に失敗しました';
    }
    return error;
  }

  Future<String?> approval({
    required ApplyProposalModel proposal,
    required UserModel? loginUser,
    required bool isAdmin,
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
        'userAdmin': isAdmin,
        'approvedAt': DateTime.now(),
      });
      if (isAdmin) {
        _proposalService.update({
          'id': proposal.id,
          'approval': 1,
          'approvedAt': DateTime.now(),
          'approvalUsers': approvalUsers,
        });
      } else {
        _proposalService.update({
          'id': proposal.id,
          'approvalUsers': approvalUsers,
        });
      }
      //通知
      List<UserModel> sendUsers = [];
      sendUsers = await _userService.selectList(
        userIds: [proposal.createdUserId],
      );
      if (sendUsers.isNotEmpty) {
        for (UserModel user in sendUsers) {
          if (user.id == loginUser.id) continue;
          _fmService.send(
            token: user.token,
            title: proposal.title,
            body: '稟議申請が承認されました。',
          );
        }
      }
    } catch (e) {
      error = '承認に失敗しました';
    }
    return error;
  }

  Future<String?> reject({
    required ApplyProposalModel proposal,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '否決に失敗しました';
    try {
      _proposalService.update({
        'id': proposal.id,
        'approval': 9,
      });
      //通知
      List<UserModel> sendUsers = [];
      sendUsers = await _userService.selectList(
        userIds: [proposal.createdUserId],
      );
      if (sendUsers.isNotEmpty) {
        for (UserModel user in sendUsers) {
          if (user.id == loginUser.id) continue;
          _fmService.send(
            token: user.token,
            title: proposal.title,
            body: '稟議申請が否決されました。',
          );
        }
      }
    } catch (e) {
      error = '否決に失敗しました';
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
      if (proposal.file != '') {
        await storage.FirebaseStorage.instance
            .ref()
            .child('applyProposal')
            .child('/${proposal.id}${proposal.fileExt}')
            .delete();
      }
    } catch (e) {
      error = '稟議申請の削除に失敗しました';
    }
    return error;
  }
}
