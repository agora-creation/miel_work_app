import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/chat.dart';
import 'package:miel_work_app/widgets/alert_chip.dart';

class ChatList extends StatelessWidget {
  final ChatModel chat;
  final int unreadCount;
  final Function()? onTap;

  const ChatList({
    required this.chat,
    required this.unreadCount,
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
        trailing: unreadCount > 0
            ? AlertChip(unreadCount.toString())
            : const Icon(
                Icons.chevron_right,
                color: kGreyColor,
              ),
        onTap: onTap,
      ),
    );
  }
}
