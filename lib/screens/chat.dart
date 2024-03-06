import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/chat.dart';
import 'package:miel_work_app/models/chat_message.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/chat_message.dart';
import 'package:miel_work_app/services/chat.dart';
import 'package:miel_work_app/services/chat_message.dart';
import 'package:miel_work_app/widgets/chat_list.dart';

class ChatScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ChatScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatService chatService = ChatService();
  ChatMessageService messageService = ChatMessageService();
  List<ChatModel> chats = [];

  void _init() async {
    chats = await chatService.selectList(
      organizationId: widget.loginProvider.organization?.id,
      groupId: widget.homeProvider.currentGroup?.id,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: kBlackColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'チャットルーム一覧',
          style: TextStyle(color: kBlackColor),
        ),
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          ChatModel chat = chats[index];
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: messageService.streamList(
              chatId: chat.id,
            ),
            builder: (context, snapshot) {
              List<ChatMessageModel> messages = [];
              if (snapshot.hasData) {
                messages = messageService.generateListUnread(
                  data: snapshot.data,
                  loginUser: widget.loginProvider.user,
                );
              }
              return ChatList(
                chat: chat,
                unreadCount: messages.length,
                onTap: () => pushScreen(
                  context,
                  ChatMessageScreen(
                    loginProvider: widget.loginProvider,
                    chat: chat,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
