import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      child: ListTile(
        title: Text(
          '${chat.name} (${chat.userIds.length})',
          style: const TextStyle(fontSize: 18),
        ),
        subtitle: Text(
          chat.lastMessage,
          style: const TextStyle(fontSize: 14),
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        trailing: unreadCount > 0
            ? AlertChip(unreadCount.toString())
            : const FaIcon(
                FontAwesomeIcons.chevronRight,
                color: kDisabledColor,
                size: 16,
              ),
        onTap: onTap,
      ),
    );
  }
}
