import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/chat.dart';

class ChatRoomList extends StatelessWidget {
  final ChatModel chat;
  final Function()? onTap;

  const ChatRoomList({
    required this.chat,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: kGrey600Color),
        ),
      ),
      child: ListTile(
        title: Text('${chat.name} (${chat.userIds.length})'),
        subtitle: Text(chat.lastMessage),
        trailing: const Icon(
          Icons.chevron_right,
          color: kGreyColor,
        ),
        onTap: onTap,
      ),
    );
  }
}
