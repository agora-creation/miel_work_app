import 'package:flutter/material.dart';
import 'package:miel_work_app/models/notice.dart';
import 'package:miel_work_app/models/organization.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/fm.dart';
import 'package:miel_work_app/services/notice.dart';
import 'package:miel_work_app/services/user.dart';

class NoticeProvider with ChangeNotifier {
  final NoticeService _noticeService = NoticeService();
  final UserService _userService = UserService();
  final FmService _fmService = FmService();

  Future<String?> create({
    required OrganizationModel? organization,
    required String title,
    required String content,
    required OrganizationGroupModel? group,
    required UserModel? user,
  }) async {
    String? error;
    if (organization == null) return 'お知らせの追加に失敗しました';
    if (title == '') return 'タイトルを入力してください';
    if (content == '') return 'お知らせ内容を入力してください';
    try {
      String id = _noticeService.id();
      _noticeService.create({
        'id': id,
        'organizationId': organization.id,
        'groupId': group?.id ?? '',
        'title': title,
        'content': content,
        'readUserIds': [user?.id],
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
          _fmService.send(
            token: user.token,
            title: title,
            body: content,
          );
        }
      }
    } catch (e) {
      error = 'お知らせの追加に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required NoticeModel notice,
    required String title,
    required String content,
    required OrganizationGroupModel? group,
    required UserModel? user,
  }) async {
    String? error;
    if (title == '') return 'タイトルを入力してください';
    if (content == '') return 'お知らせ内容を入力してください';
    try {
      _noticeService.update({
        'id': notice.id,
        'groupId': group?.id ?? '',
        'title': title,
        'content': content,
        'readUserIds': [user?.id],
      });
    } catch (e) {
      error = 'お知らせの編集に失敗しました';
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
    } catch (e) {
      error = 'お知らせの削除に失敗しました';
    }
    return error;
  }
}
