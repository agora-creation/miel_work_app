import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/chat_message.dart';
import 'package:miel_work_app/models/user.dart';

class MessageList extends StatelessWidget {
  final ChatMessageModel message;
  final bool isMe;
  final Function()? onTapImage;
  final List<UserModel> users;

  const MessageList({
    required this.message,
    required this.isMe,
    required this.onTapImage,
    required this.users,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (isMe) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            message.image == ''
                ? Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    color: kBlueColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: Text(
                        message.content,
                        style: const TextStyle(color: kWhiteColor),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: onTapImage,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      color: kBlueColor,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          message.image,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
            Text(
              dateText('MM/dd HH:mm', message.createdAt),
              style: const TextStyle(
                color: kGreyColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    } else {
      String userName = '';
      for (UserModel user in users) {
        if (user.id == message.userId) {
          userName = user.name;
        }
      }
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 2),
            message.image == ''
                ? Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    color: kWhiteColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: Text(message.content),
                    ),
                  )
                : GestureDetector(
                    onTap: onTapImage,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      color: kWhiteColor,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          message.image,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
            Text(
              dateText('MM/dd HH:mm', message.createdAt),
              style: const TextStyle(
                color: kGreyColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }
  }
}
