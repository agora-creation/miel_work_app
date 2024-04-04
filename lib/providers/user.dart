import 'package:flutter/material.dart';
import 'package:miel_work_app/models/chat.dart';
import 'package:miel_work_app/models/organization.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/chat.dart';
import 'package:miel_work_app/services/organization.dart';
import 'package:miel_work_app/services/organization_group.dart';
import 'package:miel_work_app/services/user.dart';

class UserProvider with ChangeNotifier {
  final OrganizationService _organizationService = OrganizationService();
  final OrganizationGroupService _groupService = OrganizationGroupService();
  final UserService _userService = UserService();
  final ChatService _chatService = ChatService();

  Future<String?> create({
    required OrganizationModel? organization,
    required String name,
    required String email,
    required String password,
    required OrganizationGroupModel? group,
    required bool admin,
    required bool president,
  }) async {
    String? error;
    if (organization == null) return 'スタッフの追加に失敗しました';
    if (name == '') return 'スタッフ名を入力してください';
    if (email == '') return 'メールアドレスを入力してください';
    if (password == '') return 'パスワードを入力してください';
    if (await _userService.emailCheck(email: email)) {
      return '他のメールアドレスを入力してください';
    }
    try {
      String id = _userService.id();
      _userService.create({
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'uid': '',
        'token': '',
        'admin': admin,
        'president': president,
        'createdAt': DateTime.now(),
      });
      List<String> orgUserIds = organization.userIds;
      if (!orgUserIds.contains(id)) {
        orgUserIds.add(id);
      }
      _organizationService.update({
        'id': organization.id,
        'userIds': orgUserIds,
      });
      ChatModel? orgChat = await _chatService.selectData(
        organizationId: organization.id,
        groupId: '',
      );
      if (orgChat != null) {
        _chatService.update({
          'id': orgChat.id,
          'userIds': orgUserIds,
        });
      }
      if (group != null) {
        List<String> groupUserIds = group.userIds;
        if (!groupUserIds.contains(id)) {
          groupUserIds.add(id);
        }
        _groupService.update({
          'id': group.id,
          'organizationId': group.organizationId,
          'userIds': groupUserIds,
        });
        ChatModel? groupChat = await _chatService.selectData(
          organizationId: organization.id,
          groupId: group.id,
        );
        if (groupChat != null) {
          _chatService.update({
            'id': groupChat.id,
            'userIds': groupUserIds,
          });
        }
      }
    } catch (e) {
      error = 'スタッフの追加に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required UserModel user,
    required String name,
    required String email,
    required String password,
    required OrganizationGroupModel? befGroup,
    required OrganizationGroupModel? aftGroup,
    required bool admin,
    required bool president,
  }) async {
    String? error;
    if (name == '') return 'スタッフ名を入力してください';
    if (email == '') return 'メールアドレスを入力してください';
    if (password == '') return 'パスワードを入力してください';
    if (user.email != email) {
      if (await _userService.emailCheck(email: email)) {
        return '他のメールアドレスを入力してください';
      }
    }
    try {
      _userService.update({
        'id': user.id,
        'name': name,
        'email': email,
        'password': password,
        'admin': admin,
        'president': president,
      });
      if (befGroup != aftGroup) {
        if (befGroup != null) {
          List<String> befGroupUserIds = befGroup.userIds;
          if (befGroupUserIds.contains(user.id)) {
            befGroupUserIds.remove(user.id);
          }
          _groupService.update({
            'id': befGroup.id,
            'organizationId': befGroup.organizationId,
            'userIds': befGroupUserIds,
          });
          ChatModel? groupChat = await _chatService.selectData(
            organizationId: befGroup.organizationId,
            groupId: befGroup.id,
          );
          if (groupChat != null) {
            _chatService.update({
              'id': groupChat.id,
              'userIds': befGroupUserIds,
            });
          }
        }
        if (aftGroup != null) {
          List<String> aftGroupUserIds = aftGroup.userIds;
          if (!aftGroupUserIds.contains(user.id)) {
            aftGroupUserIds.add(user.id);
          }
          _groupService.update({
            'id': aftGroup.id,
            'organizationId': aftGroup.organizationId,
            'userIds': aftGroupUserIds,
          });
          ChatModel? groupChat = await _chatService.selectData(
            organizationId: aftGroup.organizationId,
            groupId: aftGroup.id,
          );
          if (groupChat != null) {
            _chatService.update({
              'id': groupChat.id,
              'userIds': aftGroupUserIds,
            });
          }
        }
      }
    } catch (e) {
      error = 'スタッフ情報の編集に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required OrganizationModel? organization,
    required UserModel user,
    required OrganizationGroupModel? group,
  }) async {
    String? error;
    if (organization == null) return 'スタッフの削除に失敗しました';
    try {
      _userService.delete({
        'id': user.id,
      });
      List<String> orgUserIds = organization.userIds;
      if (orgUserIds.contains(user.id)) {
        orgUserIds.remove(user.id);
      }
      _organizationService.update({
        'id': organization.id,
        'userIds': orgUserIds,
      });
      ChatModel? orgChat = await _chatService.selectData(
        organizationId: organization.id,
        groupId: '',
      );
      if (orgChat != null) {
        _chatService.update({
          'id': orgChat.id,
          'userIds': orgUserIds,
        });
      }
      if (group != null) {
        List<String> groupUserIds = group.userIds;
        if (groupUserIds.contains(user.id)) {
          groupUserIds.remove(user.id);
        }
        _groupService.update({
          'id': group.id,
          'organizationId': group.organizationId,
          'userIds': groupUserIds,
        });
        ChatModel? groupChat = await _chatService.selectData(
          organizationId: group.organizationId,
          groupId: group.id,
        );
        if (groupChat != null) {
          _chatService.update({
            'id': groupChat.id,
            'userIds': groupUserIds,
          });
        }
      }
    } catch (e) {
      error = 'スタッフの削除に失敗しました';
    }
    return error;
  }
}
