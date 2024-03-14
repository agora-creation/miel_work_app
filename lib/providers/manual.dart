import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/material.dart';
import 'package:miel_work_app/models/manual.dart';
import 'package:miel_work_app/models/organization.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/fm.dart';
import 'package:miel_work_app/services/manual.dart';
import 'package:miel_work_app/services/user.dart';

class ManualProvider with ChangeNotifier {
  final ManualService _manualService = ManualService();
  final UserService _userService = UserService();
  final FmService _fmService = FmService();

  Future<String?> create({
    required OrganizationModel? organization,
    required String title,
    required File? pickedFile,
    required OrganizationGroupModel? group,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '業務マニュアルの追加に失敗しました';
    if (title == '') return 'タイトルを入力してください';
    if (pickedFile == null) return 'PDFファイルを選択してください';
    if (loginUser == null) return '業務マニュアルの追加に失敗しました';
    try {
      String id = _manualService.id();
      String file = '';
      storage.UploadTask uploadTask;
      storage.Reference ref = storage.FirebaseStorage.instance
          .ref()
          .child('manual')
          .child('/$id.pdf');
      final metadata = storage.SettableMetadata(contentType: 'application/pdf');
      uploadTask = ref.putData(pickedFile.readAsBytesSync(), metadata);
      await uploadTask.whenComplete(() => null);
      file = await ref.getDownloadURL();
      _manualService.create({
        'id': id,
        'organizationId': organization.id,
        'groupId': group?.id ?? '',
        'title': title,
        'file': file,
        'readUserIds': [loginUser.id],
        'createdAt': DateTime.now(),
      });
      //通知
      List<UserModel> sendUsers = [];
      if (group != null) {
        sendUsers = await _userService.selectList(
          userIds: group.userIds,
        );
      } else {
        sendUsers = await _userService.selectList(
          userIds: organization.userIds,
        );
      }
      if (sendUsers.isNotEmpty) {
        for (UserModel user in sendUsers) {
          if (user.id == loginUser.id) continue;
          _fmService.send(
            token: user.token,
            title: title,
            body: '業務マニュアルが追加されました。',
          );
        }
      }
    } catch (e) {
      error = '業務マニュアルの追加に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required OrganizationModel? organization,
    required ManualModel manual,
    required String title,
    required File? pickedFile,
    required OrganizationGroupModel? group,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '業務マニュアルの編集に失敗しました';
    if (title == '') return 'タイトルを入力してください';
    if (loginUser == null) return '業務マニュアルの編集に失敗しました';
    try {
      if (pickedFile != null) {
        storage.UploadTask uploadTask;
        storage.Reference ref = storage.FirebaseStorage.instance
            .ref()
            .child('manual')
            .child('/${manual.id}.pdf');
        final metadata =
            storage.SettableMetadata(contentType: 'application/pdf');
        uploadTask = ref.putData(pickedFile.readAsBytesSync(), metadata);
        await uploadTask.whenComplete(() => null);
      }
      _manualService.update({
        'id': manual.id,
        'groupId': group?.id ?? '',
        'title': title,
        'readUserIds': [loginUser.id],
      });
      //通知
      List<UserModel> sendUsers = [];
      if (group != null) {
        sendUsers = await _userService.selectList(
          userIds: group.userIds,
        );
      } else {
        sendUsers = await _userService.selectList(
          userIds: organization.userIds,
        );
      }
      if (sendUsers.isNotEmpty) {
        for (UserModel user in sendUsers) {
          if (user.id == loginUser.id) continue;
          _fmService.send(
            token: user.token,
            title: title,
            body: '業務マニュアルが編集されました。',
          );
        }
      }
    } catch (e) {
      error = '業務マニュアルの編集に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required ManualModel manual,
  }) async {
    String? error;
    try {
      _manualService.delete({
        'id': manual.id,
      });
      await storage.FirebaseStorage.instance
          .ref()
          .child('manual')
          .child('/${manual.id}.pdf')
          .delete();
    } catch (e) {
      error = '業務マニュアルの削除に失敗しました';
    }
    return error;
  }
}
