import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/chat_message.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
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
  ChatMessageService messageService = ChatMessageService();

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
            vertical: 10,
            horizontal: 14,
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: messageService.streamListUnread(
                  organizationId: widget.loginProvider.organization?.id,
                ),
                builder: (context, snapshot) {
                  List<ChatMessageModel> messages = [];
                  List<ChatMessageModel> viewMessages = [];
                  if (snapshot.hasData) {
                    messages = messageService.generateListUnread(
                      data: snapshot.data,
                      currentGroup: widget.homeProvider.currentGroup,
                      loginUser: widget.loginProvider.user,
                    );
                  }
                  if (messages.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(8),
                      child: Center(child: Text('未読のメッセージはありません')),
                    );
                  } else {
                    int count = 0;
                    for (ChatMessageModel message in messages) {
                      viewMessages.add(message);
                      count++;
                      if (count == 3) break;
                    }
                  }
                  return Column(
                    children: viewMessages.map((message) {
                      return NonReadMessageList(message: message);
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
