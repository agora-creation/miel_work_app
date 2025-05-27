import 'package:flutter/material.dart';
import 'package:miel_work_app/models/chat.dart';
import 'package:miel_work_app/models/organization.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/chat.dart';
import 'package:miel_work_app/services/log.dart';
import 'package:miel_work_app/services/organization.dart';
import 'package:miel_work_app/services/organization_group.dart';
import 'package:miel_work_app/services/user.dart';

class UserProvider with ChangeNotifier {
  final OrganizationService _organizationService = OrganizationService();
  final OrganizationGroupService _groupService = OrganizationGroupService();
  final UserService _userService = UserService();
  final ChatService _chatService = ChatService();
  final LogService _logService = LogService();

  Future<String?> create({
    required OrganizationModel? organization,
    required String name,
    required String email,
    required String password,
    required OrganizationGroupModel? group,
    required bool admin,
    required bool president,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return 'スタッフの追加に失敗しました';
    if (name == '') return 'スタッフ名は必須入力です';
    if (email == '') return 'メールアドレスは必須入力です';
    if (password == '') return 'パスワードは必須入力です';
    if (await _userService.emailCheck(email: email)) {
      return '他のメールアドレスを入力してください';
    }
    if (loginUser == null) return 'スタッフの追加に失敗しました';
    try {
      String id = _userService.id();
      _userService.create({
        'id': id,
        'number': '',
        'name': name,
        'email': email,
        'password': password,
        'job': '',
        'uid': '',
        'tokens': [],
        'admin': admin,
        'president': president,
        'resigned': false,
        'createdAt': DateTime.now(),
      });
      //会社のユーザID配列に追加
      List<String> organizationUserIds = organization.userIds;
      if (!organizationUserIds.contains(id)) {
        organizationUserIds.add(id);
      }
      _organizationService.update({
        'id': organization.id,
        'userIds': organizationUserIds,
      });
      if (group != null) {
        //グループに所属している場合
        //グループのユーザID配列に追加
        List<String> groupUserIds = group.userIds;
        if (!groupUserIds.contains(id)) {
          groupUserIds.add(id);
        }
        _groupService.update({
          'id': group.id,
          'organizationId': group.organizationId,
          'userIds': groupUserIds,
        });
        //チャットのユーザID配列に追加
        ChatModel? groupChat = await _chatService.selectData(
          organizationId: organization.id,
          groupId: group.id,
        );
        if (groupChat != null) {
          List<String> groupChatUserIds = groupChat.userIds;
          if (!groupChatUserIds.contains(id)) {
            groupChatUserIds.add(id);
          }
          _chatService.update({
            'id': groupChat.id,
            'userIds': groupChatUserIds,
          });
        }
      } else {
        //グループに所属していない場合
        //チャットのユーザID配列に追加
        List<ChatModel> chats = await _chatService.selectList(
          organizationId: organization.id,
          groupId: null,
        );
        for (final chat in chats) {
          List<String> chatUserIds = chat.userIds;
          if (!chatUserIds.contains(id)) {
            chatUserIds.add(id);
          }
          _chatService.update({
            'id': chat.id,
            'userIds': chatUserIds,
          });
        }
      }
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': organization.id,
        'content': 'スタッフを追加しました。',
        'device': 'SP(アプリ)',
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = 'スタッフの追加に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required OrganizationModel? organization,
    required UserModel user,
    required String name,
    required String email,
    required String password,
    required OrganizationGroupModel? befGroup,
    required OrganizationGroupModel? aftGroup,
    required bool admin,
    required bool president,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return 'スタッフ情報の編集に失敗しました';
    if (name == '') return 'スタッフ名は必須入力です';
    if (email == '') return 'メールアドレスは必須入力です';
    if (password == '') return 'パスワードは必須入力です';
    if (user.email != email) {
      if (await _userService.emailCheck(email: email)) {
        return '他のメールアドレスを入力してください';
      }
    }
    if (loginUser == null) return 'スタッフ情報の編集に失敗しました';
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
        //所属→所属
        if (befGroup != null && aftGroup != null) {
          //グループのユーザID配列から削除
          List<String> befGroupUserIds = befGroup.userIds;
          if (befGroupUserIds.contains(user.id)) {
            befGroupUserIds.remove(user.id);
          }
          _groupService.update({
            'id': befGroup.id,
            'organizationId': befGroup.organizationId,
            'userIds': befGroupUserIds,
          });
          //グループのユーザID配列に追加
          List<String> aftGroupUserIds = aftGroup.userIds;
          if (!aftGroupUserIds.contains(user.id)) {
            aftGroupUserIds.add(user.id);
          }
          _groupService.update({
            'id': aftGroup.id,
            'organizationId': aftGroup.organizationId,
            'userIds': aftGroupUserIds,
          });
          //チャットのユーザID配列から削除
          ChatModel? befGroupChat = await _chatService.selectData(
            organizationId: befGroup.organizationId,
            groupId: befGroup.id,
          );
          if (befGroupChat != null) {
            List<String> befGroupChatUserIds = befGroupChat.userIds;
            if (befGroupChatUserIds.contains(user.id)) {
              befGroupChatUserIds.remove(user.id);
            }
            _chatService.update({
              'id': befGroupChat.id,
              'userIds': befGroupChatUserIds,
            });
          }
          //チャットのユーザID配列に追加
          ChatModel? aftGroupChat = await _chatService.selectData(
            organizationId: aftGroup.organizationId,
            groupId: aftGroup.id,
          );
          if (aftGroupChat != null) {
            List<String> aftGroupChatUserIds = aftGroupChat.userIds;
            if (!aftGroupChatUserIds.contains(user.id)) {
              aftGroupChatUserIds.add(user.id);
            }
            _chatService.update({
              'id': aftGroupChat.id,
              'userIds': aftGroupChatUserIds,
            });
          }
        }
        //所属→未所属
        if (befGroup != null && aftGroup == null) {
          //グループのユーザID配列から削除
          List<String> befGroupUserIds = befGroup.userIds;
          if (befGroupUserIds.contains(user.id)) {
            befGroupUserIds.remove(user.id);
          }
          _groupService.update({
            'id': befGroup.id,
            'organizationId': befGroup.organizationId,
            'userIds': befGroupUserIds,
          });
          //チャットのユーザID配列に追加
          List<ChatModel> chats = await _chatService.selectList(
            organizationId: organization.id,
            groupId: null,
          );
          for (final chat in chats) {
            List<String> chatUserIds = chat.userIds;
            if (!chatUserIds.contains(user.id)) {
              chatUserIds.add(user.id);
            }
            _chatService.update({
              'id': chat.id,
              'userIds': chatUserIds,
            });
          }
        }
        //未所属→所属
        if (befGroup == null && aftGroup != null) {
          List<String> aftGroupUserIds = aftGroup.userIds;
          if (!aftGroupUserIds.contains(user.id)) {
            aftGroupUserIds.add(user.id);
          }
          _groupService.update({
            'id': aftGroup.id,
            'organizationId': aftGroup.organizationId,
            'userIds': aftGroupUserIds,
          });
          //チャットのユーザID配列から削除
          List<ChatModel> chats = await _chatService.selectList(
            organizationId: organization.id,
            groupId: null,
          );
          for (final chat in chats) {
            List<String> chatUserIds = chat.userIds;
            if (chatUserIds.contains(user.id)) {
              chatUserIds.remove(user.id);
            }
            _chatService.update({
              'id': chat.id,
              'userIds': chatUserIds,
            });
          }
          ChatModel? aftGroupChat = await _chatService.selectData(
            organizationId: aftGroup.organizationId,
            groupId: aftGroup.id,
          );
          if (aftGroupChat != null) {
            List<String> aftGroupChatUserIds = aftGroupChat.userIds;
            if (!aftGroupChatUserIds.contains(user.id)) {
              aftGroupChatUserIds.add(user.id);
            }
            _chatService.update({
              'id': aftGroupChat.id,
              'userIds': aftGroupChatUserIds,
            });
          }
        }
      }
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': organization.id,
        'content': 'スタッフ情報を編集しました。',
        'device': 'SP(アプリ)',
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = 'スタッフ情報の編集に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required OrganizationModel? organization,
    required UserModel user,
    required OrganizationGroupModel? group,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return 'スタッフ情報の削除に失敗しました';
    if (loginUser == null) return 'スタッフ情報の削除に失敗しました';
    try {
      _userService.delete({
        'id': user.id,
      });
      //会社のユーザID配列から削除
      List<String> organizationUserIds = organization.userIds;
      if (organizationUserIds.contains(user.id)) {
        organizationUserIds.remove(user.id);
      }
      _organizationService.update({
        'id': organization.id,
        'userIds': organizationUserIds,
      });
      if (group != null) {
        //グループに所属している場合
        List<String> groupUserIds = group.userIds;
        if (groupUserIds.contains(user.id)) {
          groupUserIds.remove(user.id);
        }
        _groupService.update({
          'id': group.id,
          'organizationId': group.organizationId,
          'userIds': groupUserIds,
        });
      }
      //チャットのユーザID配列から削除
      List<ChatModel> chats = await _chatService.selectList(
        organizationId: organization.id,
        groupId: null,
      );
      for (final chat in chats) {
        List<String> chatUserIds = chat.userIds;
        if (chatUserIds.contains(user.id)) {
          chatUserIds.remove(user.id);
        }
        _chatService.update({
          'id': chat.id,
          'userIds': chatUserIds,
        });
      }
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': organization.id,
        'content': 'スタッフを削除しました。',
        'device': 'SP(アプリ)',
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = 'スタッフ情報の削除に失敗しました';
    }
    return error;
  }
}
