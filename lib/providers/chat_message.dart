import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miel_work_app/models/chat.dart';
import 'package:miel_work_app/models/chat_message.dart';
import 'package:miel_work_app/models/reply_source.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/chat.dart';
import 'package:miel_work_app/services/chat_message.dart';
import 'package:miel_work_app/services/fm.dart';
import 'package:miel_work_app/services/user.dart';
import 'package:path/path.dart' as p;

class ChatMessageProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();
  final ChatMessageService _messageService = ChatMessageService();
  final UserService _userService = UserService();
  final FmService _fmService = FmService();

  TextEditingController contentController = TextEditingController();
  FocusNode contentFocusNode = FocusNode();

  Future<String?> send({
    required ChatModel? chat,
    required UserModel? loginUser,
    required ReplySourceModel? replySource,
  }) async {
    String? error;
    if (chat == null) return 'メッセージの送信に失敗しました';
    if (loginUser == null) return 'メッセージの送信に失敗しました';
    if (contentController.text == '') return 'メッセージを入力してください';
    try {
      String id = _messageService.id();
      List<Map> readUsers = [];
      readUsers.add({
        'userId': loginUser.id,
        'userName': loginUser.name,
        'createdAt': DateTime.now(),
      });
      _messageService.create({
        'id': id,
        'organizationId': chat.organizationId,
        'groupId': chat.groupId,
        'chatId': chat.id,
        'content': contentController.text,
        'image': '',
        'file': '',
        'fileExt': '',
        'readUsers': readUsers,
        'favoriteUserIds': [],
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
        'expirationAt': DateTime.now().add(const Duration(days: 365)),
        'replySource': replySource?.toMap(),
      });
      _chatService.update({
        'id': chat.id,
        'lastMessage': contentController.text,
        'updatedAt': DateTime.now(),
      });
      //通知
      List<UserModel> sendUsers = await _userService.selectList(
        userIds: chat.userIds,
      );
      if (sendUsers.isNotEmpty) {
        for (UserModel user in sendUsers) {
          if (user.id == loginUser.id) continue;
          _fmService.send(
            token: user.token,
            title: '[${chat.name}]${loginUser.name}からのメッセージ',
            body: contentController.text,
          );
        }
      }
      contentController.clear();
      contentFocusNode.unfocus();
    } catch (e) {
      error = 'メッセージの送信に失敗しました';
    }
    return error;
  }

  Future<String?> sendImage({
    required ChatModel? chat,
    required UserModel? loginUser,
    required XFile imageXFile,
  }) async {
    String? error;
    if (chat == null) return 'メッセージの送信に失敗しました';
    if (loginUser == null) return 'メッセージの送信に失敗しました';
    try {
      String id = _messageService.id();
      String content = '画像を送信しました';
      File imageFile = File(imageXFile.path);
      // //画像圧縮
      // var imageFileCompress = await FlutterImageCompress.compressWithFile(
      //   imageFile.path,
      //   quality: 80,
      // );
      // if (imageFileCompress != null) {
      //   imageFile = File.fromRawPath(imageFileCompress);
      // }
      FirebaseStorage storage = FirebaseStorage.instance;
      String storagePath = 'chat/${chat.id}/$id';
      final task = await storage.ref(storagePath).putFile(imageFile);
      List<Map> readUsers = [];
      readUsers.add({
        'userId': loginUser.id,
        'userName': loginUser.name,
        'createdAt': DateTime.now(),
      });
      _messageService.create({
        'id': id,
        'organizationId': chat.organizationId,
        'groupId': chat.groupId,
        'chatId': chat.id,
        'content': content,
        'image': await task.ref.getDownloadURL(),
        'file': '',
        'fileExt': '',
        'readUsers': readUsers,
        'favoriteUserIds': [],
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
        'expirationAt': DateTime.now().add(const Duration(days: 365)),
        'replySource': null,
      });
      _chatService.update({
        'id': chat.id,
        'lastMessage': content,
        'updatedAt': DateTime.now(),
      });
      //通知
      List<UserModel> sendUsers = await _userService.selectList(
        userIds: chat.userIds,
      );
      if (sendUsers.isNotEmpty) {
        for (UserModel user in sendUsers) {
          if (user.id == loginUser.id) continue;
          _fmService.send(
            token: user.token,
            title: '[${chat.name}]${loginUser.name}からのメッセージ',
            body: content,
          );
        }
      }
      contentController.clear();
      contentFocusNode.unfocus();
    } catch (e) {
      error = 'メッセージの送信に失敗しました';
    }
    return error;
  }

  Future<String?> sendFile({
    required ChatModel? chat,
    required UserModel? loginUser,
    required File pickedFile,
  }) async {
    String? error;
    if (chat == null) return 'メッセージの送信に失敗しました';
    if (loginUser == null) return 'メッセージの送信に失敗しました';
    try {
      String id = _messageService.id();
      String content = 'ファイルを送信しました';
      String ext = p.extension(pickedFile.path);
      UploadTask uploadTask;
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('chat/${chat.id}')
          .child('/$id$ext');
      uploadTask = ref.putData(pickedFile.readAsBytesSync());
      await uploadTask.whenComplete(() => null);
      List<Map> readUsers = [];
      readUsers.add({
        'userId': loginUser.id,
        'userName': loginUser.name,
        'createdAt': DateTime.now(),
      });
      _messageService.create({
        'id': id,
        'organizationId': chat.organizationId,
        'groupId': chat.groupId,
        'chatId': chat.id,
        'content': content,
        'image': '',
        'file': await ref.getDownloadURL(),
        'fileExt': ext,
        'readUsers': readUsers,
        'favoriteUserIds': [],
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
        'expirationAt': DateTime.now().add(const Duration(days: 365)),
        'replySource': null,
      });
      _chatService.update({
        'id': chat.id,
        'lastMessage': content,
        'updatedAt': DateTime.now(),
      });
      //通知
      List<UserModel> sendUsers = await _userService.selectList(
        userIds: chat.userIds,
      );
      if (sendUsers.isNotEmpty) {
        for (UserModel user in sendUsers) {
          if (user.id == loginUser.id) continue;
          _fmService.send(
            token: user.token,
            title: '[${chat.name}]${loginUser.name}からのメッセージ',
            body: content,
          );
        }
      }
      contentController.clear();
      contentFocusNode.unfocus();
    } catch (e) {
      error = 'メッセージの送信に失敗しました';
    }
    return error;
  }

  Future<String?> favorite({
    required ChatMessageModel message,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return 'メッセージのいいねに失敗しました';
    try {
      List<String> favoriteUserIds = message.favoriteUserIds;
      if (!favoriteUserIds.contains(loginUser.id)) {
        favoriteUserIds.add(loginUser.id);
      }
      _messageService.update({
        'id': message.id,
        'favoriteUserIds': favoriteUserIds,
      });
    } catch (e) {
      error = 'メッセージのいいねに失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required ChatMessageModel message,
  }) async {
    String? error;
    try {
      _messageService.delete({
        'id': message.id,
      });
      if (message.image != '') {
        await FirebaseStorage.instance
            .ref()
            .child('chat/${message.chatId}/${message.id}')
            .delete();
      }
      if (message.file != '') {
        await FirebaseStorage.instance
            .ref()
            .child('chat/${message.chatId}/${message.id}${message.fileExt}')
            .delete();
      }
    } catch (e) {
      error = 'メッセージの削除に失敗しました';
    }
    return error;
  }
}
