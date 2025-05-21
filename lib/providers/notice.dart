import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/models/notice.dart';
import 'package:miel_work_app/models/organization.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/fm.dart';
import 'package:miel_work_app/services/notice.dart';
import 'package:miel_work_app/services/user.dart';
import 'package:path/path.dart' as p;

class NoticeProvider with ChangeNotifier {
  final NoticeService _noticeService = NoticeService();
  final UserService _userService = UserService();
  final FmService _fmService = FmService();

  Future<String?> create({
    required OrganizationModel? organization,
    required String title,
    required String content,
    required OrganizationGroupModel? group,
    required File? pickedFile,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return 'お知らせの追加に失敗しました';
    if (title == '') return 'タイトルは必須入力です';
    if (content == '') return 'お知らせ内容は必須入力です';
    if (loginUser == null) return 'お知らせの追加に失敗しました';
    try {
      String id = _noticeService.id();
      String file = '';
      String fileExt = '';
      if (pickedFile != null) {
        String ext = p.extension(pickedFile.path);
        storage.UploadTask uploadTask;
        storage.Reference ref = storage.FirebaseStorage.instance
            .ref()
            .child('notice')
            .child('/$id$ext');
        uploadTask = ref.putData(pickedFile.readAsBytesSync());
        await uploadTask.whenComplete(() => null);
        file = await ref.getDownloadURL();
        fileExt = ext;
      }
      _noticeService.create({
        'id': id,
        'organizationId': organization.id,
        'groupId': group?.id ?? '',
        'title': title,
        'content': content,
        'file': file,
        'fileExt': fileExt,
        'readUserIds': [loginUser.id],
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
        'expirationAt': DateTime.now().add(const Duration(days: 365)),
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
          for (final token in user.tokens) {
            _fmService.send(
              token: token,
              title: title,
              body: content,
            );
          }
        }
      }
    } catch (e) {
      error = 'お知らせの追加に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required OrganizationModel? organization,
    required NoticeModel notice,
    required String title,
    required String content,
    required OrganizationGroupModel? group,
    required File? pickedFile,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return 'お知らせの編集に失敗しました';
    if (title == '') return 'タイトルは必須入力です';
    if (content == '') return 'お知らせ内容は必須入力です';
    if (loginUser == null) return 'お知らせの編集に失敗しました';
    try {
      String? file;
      String? fileExt;
      if (pickedFile != null) {
        String ext = p.extension(pickedFile.path);
        storage.UploadTask uploadTask;
        storage.Reference ref = storage.FirebaseStorage.instance
            .ref()
            .child('notice')
            .child('/${notice.id}${notice.fileExt}');
        uploadTask = ref.putData(pickedFile.readAsBytesSync());
        await uploadTask.whenComplete(() => null);
        file = await ref.getDownloadURL();
        fileExt = ext;
      }
      if (file == null) {
        _noticeService.update({
          'id': notice.id,
          'groupId': group?.id ?? '',
          'title': title,
          'content': content,
          'readUserIds': [loginUser.id],
        });
      } else {
        _noticeService.update({
          'id': notice.id,
          'groupId': group?.id ?? '',
          'title': title,
          'content': content,
          'file': file,
          'fileExt': fileExt,
          'readUserIds': [loginUser.id],
        });
      }
    } catch (e) {
      error = 'お知らせの編集に失敗しました';
    }
    return error;
  }

  Future<String?> addComment({
    required OrganizationModel? organization,
    required NoticeModel notice,
    required String content,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '社内コメントの追記に失敗しました';
    if (content == '') return '社内コメントの追記に失敗しました';
    if (loginUser == null) return '社内コメントの追記に失敗しました';
    try {
      List<Map> comments = [];
      if (notice.comments.isNotEmpty) {
        for (final comment in notice.comments) {
          comments.add(comment.toMap());
        }
      }
      comments.add({
        'id': dateText('yyyyMMddHHmm', DateTime.now()),
        'userId': loginUser.id,
        'userName': loginUser.name,
        'content': content,
        'readUserIds': [loginUser.id],
        'createdAt': DateTime.now(),
      });
      _noticeService.update({
        'id': notice.id,
        'comments': comments,
      });
      //通知
      List<UserModel> sendUsers = [];
      sendUsers = await _userService.selectList(
        userIds: organization.userIds,
      );
      if (sendUsers.isNotEmpty) {
        for (UserModel user in sendUsers) {
          if (user.id == loginUser.id) continue;
          for (final token in user.tokens) {
            _fmService.send(
              token: token,
              title: '『[お知らせ]${notice.title}』に社内コメントが追記されました',
              body: content,
            );
          }
        }
      }
    } catch (e) {
      error = '社内コメントの追記に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required NoticeModel notice,
  }) async {
    String? error;
    try {
      _noticeService.delete({
        'id': notice.id,
      });
      if (notice.file != '') {
        await storage.FirebaseStorage.instance
            .ref()
            .child('notice')
            .child('/${notice.id}${notice.fileExt}')
            .delete();
      }
    } catch (e) {
      error = 'お知らせの削除に失敗しました';
    }
    return error;
  }
}
