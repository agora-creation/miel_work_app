import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/chat.dart';

class ChatList extends StatelessWidget {
  final ChatModel chat;
  final bool unread;
  final Function()? onTap;

  const ChatList({
    required this.chat,
    required this.unread,
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
        subtitle: Text(
          chat.lastMessage,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        trailing: unread
            ? const Icon(
                Icons.circle,
                color: kRedColor,
              )
            : const Icon(
                Icons.chevron_right,
                color: kGreyColor,
              ),
        onTap: onTap,
      ),
    );
  }
}
