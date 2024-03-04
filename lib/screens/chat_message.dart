import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/chat.dart';
import 'package:miel_work_app/models/chat_message.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/providers/chat_message.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/services/chat_message.dart';
import 'package:miel_work_app/services/user.dart';
import 'package:miel_work_app/widgets/message_form_field.dart';
import 'package:miel_work_app/widgets/message_list.dart';
import 'package:provider/provider.dart';

class ChatMessageScreen extends StatefulWidget {
  final ChatModel chat;

  const ChatMessageScreen({
    required this.chat,
    super.key,
  });

  @override
  State<ChatMessageScreen> createState() => _ChatMessageScreenState();
}

class _ChatMessageScreenState extends State<ChatMessageScreen> {
  ChatMessageService messageService = ChatMessageService();
  UserService userService = UserService();
  List<UserModel> users = [];

  void _init() async {
    users = await userService.selectList(
      userIds: widget.chat.userIds,
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
    final loginProvider = Provider.of<LoginProvider>(context);
    final messageProvider = Provider.of<ChatMessageProvider>(context);
    UserModel? loginUser = loginProvider.user;
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
        title: Text(
          widget.chat.name,
          style: const TextStyle(color: kBlackColor),
        ),
        actions: [
          users.isNotEmpty
              ? IconButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => ChatUsersDialog(
                      chat: widget.chat,
                      users: users,
                    ),
                  ),
                  icon: const Icon(
                    Icons.groups,
                    color: kBlueColor,
                  ),
                )
              : Container(),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: SafeArea(
        child: Focus(
          focusNode: messageProvider.contentFocusNode,
          child: GestureDetector(
            onTap: messageProvider.contentFocusNode.requestFocus,
            child: Container(
              color: kGrey200Color,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: messageService.streamList(chatId: widget.chat.id),
                      builder: (context, snapshot) {
                        List<ChatMessageModel> messages = [];
                        if (snapshot.hasData) {
                          messages = messageService.generateList(
                            data: snapshot.data,
                          );
                        }
                        if (messages.isEmpty) {
                          return const Center(child: Text('メッセージがありません'));
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.all(8),
                          reverse: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            ChatMessageModel message = messages[index];
                            return MessageList(
                              message: message,
                              isMe: message.userId == loginUser?.id,
                              onTapImage: () {},
                              users: users,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  MessageFormField(
                    controller: messageProvider.contentController,
                    galleryPressed: () {},
                    sendPressed: () async {
                      String? error = await messageProvider.send(
                        chat: widget.chat,
                        loginUser: loginUser,
                      );
                      if (error != null) {
                        if (!mounted) return;
                        showMessage(context, error, false);
                        return;
                      }
                    },
                    enabled: widget.chat.userIds.contains(loginUser?.id),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChatUsersDialog extends StatelessWidget {
  final ChatModel chat;
  final List<UserModel> users;

  const ChatUsersDialog({
    required this.chat,
    required this.users,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      title: const Text(
        '参加スタッフ',
        style: TextStyle(fontSize: 16),
      ),
      content: Container(
        decoration: BoxDecoration(border: Border.all(color: kGrey600Color)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: users.map((user) {
              return Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: kGrey600Color)),
                ),
                child: ListTile(title: Text(user.name)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
