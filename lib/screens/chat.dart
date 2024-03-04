import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/chat.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/chat_message.dart';
import 'package:miel_work_app/services/chat.dart';
import 'package:miel_work_app/widgets/chat_room_list.dart';

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
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: chatService.streamList(
          organizationId: widget.loginProvider.organization?.id,
        ),
        builder: (context, snapshot) {
          List<ChatModel> chats = [];
          if (snapshot.hasData) {
            chats = chatService.generateList(
              data: snapshot.data,
              currentGroup: widget.homeProvider.currentGroup,
            );
          }
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              ChatModel chat = chats[index];
              return ChatRoomList(
                chat: chat,
                onTap: () => pushScreen(
                  context,
                  ChatMessageScreen(chat: chat),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
