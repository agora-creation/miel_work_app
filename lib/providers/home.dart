import 'package:flutter/material.dart';
import 'package:miel_work_app/models/chat.dart';
import 'package:miel_work_app/models/organization.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/services/chat.dart';
import 'package:miel_work_app/services/organization_group.dart';

class HomeProvider with ChangeNotifier {
  final OrganizationGroupService _groupService = OrganizationGroupService();
  final ChatService _chatService = ChatService();
  List<OrganizationGroupModel> groups = [];
  OrganizationGroupModel? currentGroup;

  void setGroups({
    String? organizationId,
    OrganizationGroupModel? group,
    bool isAllGroup = false,
  }) async {
    groups = await _groupService.selectList(
      organizationId: organizationId ?? 'error',
    );
    if (isAllGroup) {
      currentGroup = null;
    } else {
      currentGroup = group;
    }
    notifyListeners();
  }

  void currentGroupChange(OrganizationGroupModel? value) {
    currentGroup = value;
    notifyListeners();
  }

  void currentGroupClear() {
    currentGroup = null;
    notifyListeners();
  }

  Future<String?> groupCreate({
    required OrganizationModel? organization,
    required String name,
  }) async {
    String? error;
    if (organization == null) return 'グループの追加に失敗しました';
    if (name == '') return 'グループ名は必須入力です';
    try {
      String groupId = _groupService.id(organizationId: organization.id);
      _groupService.create({
        'id': groupId,
        'organizationId': organization.id,
        'name': name,
        'userIds': [],
        'loginId': '',
        'password': '',
        'createdAt': DateTime.now(),
      });
      String chatId = _chatService.id();
      //未所属のスタッフを登録
      List<String> userIds = organization.userIds;
      if (groups.isNotEmpty) {
        for (OrganizationGroupModel group in groups) {
          if (group.userIds.isNotEmpty) {
            for (String userId in group.userIds) {
              if (userIds.contains(userId)) {
                userIds.remove(userId);
              }
            }
          }
        }
      }
      _chatService.create({
        'id': chatId,
        'organizationId': organization.id,
        'groupId': groupId,
        'userIds': userIds,
        'name': name,
        'lastMessage': '',
        'updatedAt': DateTime.now(),
        'createdAt': DateTime.now(),
      });
      setGroups(organizationId: organization.id);
    } catch (e) {
      error = 'グループの追加に失敗しました';
    }
    return error;
  }

  Future<String?> groupUpdate({
    required OrganizationModel? organization,
    required OrganizationGroupModel? group,
    required String name,
  }) async {
    String? error;
    if (organization == null) return 'グループ名の変更に失敗しました';
    if (group == null) return 'グループ名の変更に失敗しました';
    if (name == '') return 'グループ名は必須入力です';
    try {
      _groupService.update({
        'id': group.id,
        'organizationId': group.organizationId,
        'name': name,
      });
      ChatModel? chat = await _chatService.selectData(
        organizationId: organization.id,
        groupId: group.id,
      );
      if (chat != null) {
        _chatService.update({
          'id': chat.id,
          'name': name,
        });
      }
      setGroups(organizationId: organization.id);
    } catch (e) {
      error = 'グループ名の変更に失敗しました';
    }
    return error;
  }

  Future<String?> groupDelete({
    required OrganizationModel? organization,
    required OrganizationGroupModel? group,
  }) async {
    String? error;
    if (organization == null) return 'グループの削除に失敗しました';
    if (group == null) return 'グループの削除に失敗しました';
    try {
      _groupService.delete({
        'id': group.id,
        'organizationId': group.organizationId,
      });
      ChatModel? chat = await _chatService.selectData(
        organizationId: organization.id,
        groupId: group.id,
      );
      if (chat != null) {
        _chatService.delete({
          'id': chat.id,
        });
      }
      setGroups(organizationId: organization.id);
    } catch (e) {
      error = 'グループの削除に失敗しました';
    }
    return error;
  }
}
