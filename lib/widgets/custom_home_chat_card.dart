import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/chat.dart';
import 'package:miel_work_app/models/chat_message.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/services/chat.dart';
import 'package:miel_work_app/services/chat_message.dart';
import 'package:miel_work_app/widgets/nonread_message_list.dart';

class CustomHomeChatCard extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final Function()? onTap;

  const CustomHomeChatCard({
    required this.loginProvider,
    required this.homeProvider,
    this.onTap,
    super.key,
  });

  @override
  State<CustomHomeChatCard> createState() => _CustomHomeChatCardState();
}

class _CustomHomeChatCardState extends State<CustomHomeChatCard> {
  ChatService chatService = ChatService();
  ChatMessageService messageService = ChatMessageService();
  List<ChatMessageModel> messages = [];
  List<Widget> messageChildren = [];
  bool other = false;

  void _init() async {
    List<ChatModel> chats = await chatService.selectList(
      organizationId: widget.loginProvider.organization?.id,
      groupId: widget.homeProvider.currentGroup?.id,
    );
    if (chats.isNotEmpty) {
      for (ChatModel chat in chats) {
        List<ChatMessageModel> tmpMessages = await messageService.selectList(
          chatId: chat.id,
          loginUser: widget.loginProvider.user,
        );
        messages.addAll(tmpMessages);
      }
    }
    if (messages.length > 3) {
      other = true;
      if (messages.isNotEmpty) {
        int count = 0;
        for (ChatMessageModel message in messages) {
          messageChildren.add(NonReadMessageList(message: message));
          count++;
          if (count >= 3) break;
        }
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: kWhiteColor,
        surfaceTintColor: kWhiteColor,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: kGrey600Color)),
                ),
                child: const Text(
                  'チャット',
                  style: TextStyle(
                    color: kBlackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(children: messageChildren),
                    other ? const Text('その他未読あり') : Container()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
