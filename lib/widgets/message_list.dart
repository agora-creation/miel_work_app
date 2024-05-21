import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/chat_message.dart';
import 'package:miel_work_app/models/read_user.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/widgets/popup_icon_button.dart';

class MessageList extends StatelessWidget {
  final ChatMessageModel message;
  final UserModel? loginUser;
  final Function() copyAction;
  final Function() deleteAction;
  final Function()? onTapReadUsers;
  final Function()? onTapImage;
  final Function()? onTapFile;

  const MessageList({
    required this.message,
    required this.loginUser,
    required this.copyAction,
    required this.deleteAction,
    required this.onTapReadUsers,
    required this.onTapImage,
    required this.onTapFile,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CustomPopupMenuController menuController = CustomPopupMenuController();

    Widget buildLongPressMenu() {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          width: 280,
          color: const Color(0xFF4C4C4C),
          child: GridView.count(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 16,
            ),
            crossAxisCount: 5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              PopupIconButton(
                icon: Icons.reply,
                label: 'リプライ',
                onTap: () {},
              ),
              PopupIconButton(
                icon: Icons.copy,
                label: 'コピー',
                onTap: () {
                  copyAction();
                  showMessage(context, 'コピーしました', true);
                  menuController.hideMenu();
                },
              ),
              PopupIconButton(
                icon: Icons.delete,
                label: '削除',
                onTap: () {
                  deleteAction();
                  menuController.hideMenu();
                },
              ),
            ],
          ),
        ),
      );
    }

    List<ReadUserModel> readUsers = [];
    for (ReadUserModel readUser in message.readUsers) {
      if (readUser.userId != loginUser?.id) {
        readUsers.add(readUser);
      }
    }
    if (message.createdUserId == loginUser?.id) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            message.image == '' && message.file == ''
                ? CustomPopupMenu(
                    menuBuilder: buildLongPressMenu,
                    barrierColor: Colors.transparent,
                    pressType: PressType.longPress,
                    controller: menuController,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      color: kYellowColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        child: Text(message.content).urlToLink(context),
                      ),
                    ),
                  )
                : Container(),
            message.image != ''
                ? GestureDetector(
                    onLongPress: onTapImage,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      color: kYellowColor,
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
                  )
                : Container(),
            message.file != ''
                ? GestureDetector(
                    onLongPress: onTapFile,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      color: kYellowColor,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.file_open),
                              const SizedBox(height: 4),
                              Text('${message.id}${message.fileExt}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            Text(
              dateText('MM/dd HH:mm', message.createdAt),
              style: const TextStyle(
                color: kGreyColor,
                fontSize: 12,
              ),
            ),
            readUsers.isNotEmpty
                ? GestureDetector(
                    onLongPress: onTapReadUsers,
                    child: Text(
                      '既読 ${readUsers.length}',
                      style: const TextStyle(
                        color: kGrey600Color,
                        fontSize: 12,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.createdUserName,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 2),
            message.image == '' && message.file == ''
                ? CustomPopupMenu(
                    menuBuilder: buildLongPressMenu,
                    barrierColor: Colors.transparent,
                    pressType: PressType.longPress,
                    controller: menuController,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      color: kWhiteColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        child: Text(message.content).urlToLink(context),
                      ),
                    ),
                  )
                : Container(),
            message.image != ''
                ? GestureDetector(
                    onLongPress: onTapImage,
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
                  )
                : Container(),
            message.file != ''
                ? GestureDetector(
                    onLongPress: onTapFile,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      color: kWhiteColor,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.file_open),
                              const SizedBox(height: 4),
                              Text('${message.id}${message.fileExt}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            Text(
              dateText('MM/dd HH:mm', message.createdAt),
              style: const TextStyle(
                color: kGreyColor,
                fontSize: 12,
              ),
            ),
            readUsers.isNotEmpty
                ? GestureDetector(
                    onLongPress: onTapReadUsers,
                    child: Text(
                      '既読 ${readUsers.length}',
                      style: const TextStyle(
                        color: kGrey600Color,
                        fontSize: 12,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      );
    }
  }
}
