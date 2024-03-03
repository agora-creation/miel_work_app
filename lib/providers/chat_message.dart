import 'package:flutter/material.dart';
import 'package:miel_work_app/models/chat.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/chat.dart';
import 'package:miel_work_app/services/chat_message.dart';

class ChatMessageProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();
  final ChatMessageService _messageService = ChatMessageService();

  TextEditingController contentController = TextEditingController();
  FocusNode contentFocusNode = FocusNode();

  Future<String?> send({
    required ChatModel? chat,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (chat == null) return 'メッセージの送信に失敗しました';
    if (loginUser == null) return 'メッセージの送信に失敗しました';
    if (contentController.text == '') return 'メッセージを入力してください';
    try {
      String id = _messageService.id(chatId: chat.id);
      _messageService.create({
        'id': id,
        'chatId': chat.id,
        'userId': loginUser.id,
        'content': contentController.text,
        'image': '',
        'createdAt': DateTime.now(),
      });
      _chatService.update({
        'id': chat.id,
        'lastMessage': contentController.text,
      });
      contentController.clear();
      contentFocusNode.unfocus();
    } catch (e) {
      error = 'メッセージの送信に失敗しました';
    }
    return error;
  }
}
