import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/chat.dart';
import 'package:miel_work_app/models/chat_message.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/chat_message.dart';
import 'package:miel_work_app/services/chat.dart';
import 'package:miel_work_app/services/chat_message.dart';
import 'package:miel_work_app/services/config.dart';
import 'package:miel_work_app/widgets/chat_list.dart';
import 'package:page_transition/page_transition.dart';

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
    await ConfigService().checkReview();
    chats = await chatService.selectList(
      organizationId: widget.loginProvider.organization?.id,
      groupId: widget.homeProvider.currentGroup?.id,
    );
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhiteColor,
        title: const Text(
          'チャット',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.xmark,
              color: kBlackColor,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
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
                  currentGroup: widget.homeProvider.currentGroup,
                  loginUser: widget.loginProvider.user,
                );
              }
              return ChatList(
                chat: chat,
                unreadCount: messages.length,
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: ChatMessageScreen(
                        loginProvider: widget.loginProvider,
                        chat: chat,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
