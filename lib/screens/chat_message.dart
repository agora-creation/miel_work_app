import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/chat.dart';
import 'package:miel_work_app/models/chat_message.dart';
import 'package:miel_work_app/models/read_user.dart';
import 'package:miel_work_app/models/reply_source.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/providers/chat_message.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/services/chat_message.dart';
import 'package:miel_work_app/services/config.dart';
import 'package:miel_work_app/services/user.dart';
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/image_detail_dialog.dart';
import 'package:miel_work_app/widgets/message_form_field.dart';
import 'package:miel_work_app/widgets/message_list.dart';
import 'package:miel_work_app/widgets/pdf_detail_dialog.dart';
import 'package:provider/provider.dart';

class ChatMessageScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ChatModel chat;

  const ChatMessageScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.chat,
    super.key,
  });

  @override
  State<ChatMessageScreen> createState() => _ChatMessageScreenState();
}

class _ChatMessageScreenState extends State<ChatMessageScreen> {
  ChatMessageService messageService = ChatMessageService();
  String searchKeyword = '';
  ReplySourceModel? replySource;

  void _getKeyword() async {
    searchKeyword = await getPrefsString('keyword') ?? '';
    setState(() {});
  }

  void _init() async {
    await ConfigService().checkReview();
    await messageService.updateRead(
      chatId: widget.chat.id,
      loginUser: widget.loginProvider.user,
    );
    setState(() {});
  }

  @override
  void initState() {
    _init();
    _getKeyword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final messageProvider = Provider.of<ChatMessageProvider>(context);
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.chevronLeft,
            color: kBlackColor,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.chat.name,
          style: const TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => SearchKeywordDialog(
                getKeyword: _getKeyword,
              ),
            ),
            icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
          ),
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => ChatUsersDialog(
                chat: widget.chat,
              ),
            ),
            icon: const FaIcon(FontAwesomeIcons.users),
          ),
        ],
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: SafeArea(
        child: Focus(
          focusNode: messageProvider.contentFocusNode,
          child: GestureDetector(
            onTap: messageProvider.contentFocusNode.requestFocus,
            child: Container(
              color: kGreyColor.withOpacity(0.3),
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
                          messages = messageService.generateListKeyword(
                            data: snapshot.data,
                            keyword: searchKeyword,
                          );
                        }
                        if (messages.isEmpty) {
                          return const Center(child: Text('メッセージがありません'));
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.all(8),
                          shrinkWrap: true,
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            ChatMessageModel message = messages[index];
                            CustomPopupMenuController menuController =
                                CustomPopupMenuController();
                            return MessageList(
                              message: message,
                              loginUser: widget.loginProvider.user,
                              menuController: menuController,
                              favoriteAction: () async {
                                menuController.hideMenu();
                                String? error = await messageProvider.favorite(
                                  message: message,
                                  loginUser: widget.loginProvider.user,
                                );
                                if (error != null) {
                                  if (!mounted) return;
                                  showMessage(context, error, false);
                                  return;
                                }
                                if (!mounted) return;
                                showMessage(context, 'いいねしました', true);
                              },
                              replyAction: () {
                                menuController.hideMenu();
                                replySource = ReplySourceModel.fromMap({
                                  'id': message.id,
                                  'content': message.content,
                                  'image': message.image,
                                  'file': message.file,
                                  'fileExt': message.fileExt,
                                  'createdUserName': message.createdUserName,
                                });
                                setState(() {});
                              },
                              copyAction: () async {
                                menuController.hideMenu();
                                final data = ClipboardData(
                                  text: message.content,
                                );
                                await Clipboard.setData(data);
                                showMessage(context, 'コピーしました', true);
                              },
                              deleteAction: () async {
                                menuController.hideMenu();
                                String? error = await messageProvider.delete(
                                  message: message,
                                );
                                if (error != null) {
                                  if (!mounted) return;
                                  showMessage(context, error, false);
                                  return;
                                }
                                if (!mounted) return;
                                showMessage(context, 'メッセージを削除しました', true);
                              },
                              onTapReadUsers: () => showDialog(
                                context: context,
                                builder: (context) => ReadUsersDialog(
                                  readUsers: message.readUsers,
                                ),
                              ),
                              onTapImage: () => showDialog(
                                barrierDismissible: true,
                                barrierLabel: '閉じる',
                                context: context,
                                builder: (context) => ImageDetailDialog(
                                  File(message.image).path,
                                  onPressedClose: () => Navigator.pop(context),
                                ),
                              ),
                              onTapFile: () {
                                String ext = message.fileExt;
                                if (imageExtensions.contains(ext)) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => ImageDetailDialog(
                                      File(message.file).path,
                                      onPressedClose: () =>
                                          Navigator.pop(context),
                                    ),
                                  );
                                }
                                if (pdfExtensions.contains(ext)) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => PdfDetailDialog(
                                      File(message.file).path,
                                      onPressedClose: () =>
                                          Navigator.pop(context),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  MessageFormField(
                    controller: messageProvider.contentController,
                    filePressed: () async {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.any,
                      );
                      if (result == null) return;
                      String? error = await messageProvider.sendFile(
                        chat: widget.chat,
                        loginUser: widget.loginProvider.user,
                        pickedFile: File(result.files.single.path!),
                      );
                      if (error != null) {
                        if (!mounted) return;
                        showMessage(context, error, false);
                        return;
                      }
                    },
                    galleryPressed: () async {
                      final result = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      if (result == null) return;
                      String? error = await messageProvider.sendImage(
                        chat: widget.chat,
                        loginUser: widget.loginProvider.user,
                        imageXFile: result,
                      );
                      if (error != null) {
                        if (!mounted) return;
                        showMessage(context, error, false);
                        return;
                      }
                    },
                    sendPressed: () async {
                      String? error = await messageProvider.send(
                        chat: widget.chat,
                        loginUser: widget.loginProvider.user,
                        replySource: replySource,
                      );
                      if (error != null) {
                        if (!mounted) return;
                        showMessage(context, error, false);
                        return;
                      }
                      replySource = null;
                      setState(() {});
                    },
                    enabled: widget.chat.userIds
                        .contains(widget.loginProvider.user?.id),
                    replySource: replySource,
                    replyClosed: () {
                      replySource = null;
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomFooter(
        loginProvider: widget.loginProvider,
        homeProvider: widget.homeProvider,
      ),
    );
  }
}

// class ImageDialog extends StatefulWidget {
//   final ChatMessageProvider messageProvider;
//   final ChatMessageModel message;
//   final String file;
//
//   const ImageDialog({
//     required this.messageProvider,
//     required this.message,
//     this.file = '',
//     super.key,
//   });
//
//   @override
//   State<ImageDialog> createState() => _ImageDialogState();
// }
//
// class _ImageDialogState extends State<ImageDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.topCenter,
//       children: [
//         Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Expanded(
//               child: InteractiveViewer(
//                 minScale: 0.1,
//                 maxScale: 5,
//                 child: Image.network(
//                   widget.file == ''
//                       ? widget.message.image
//                       : File(widget.file).path,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Material(
//               elevation: 8,
//               borderRadius: BorderRadius.circular(100),
//               color: kWhiteColor,
//               child: IconButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 icon: const FaIcon(
//                   FontAwesomeIcons.xmark,
//                   color: kBlackColor,
//                   size: 30,
//                 ),
//               ),
//             ),
//             Material(
//               elevation: 8,
//               borderRadius: BorderRadius.circular(100),
//               color: kWhiteColor,
//               child: IconButton(
//                 onPressed: () async {
//                   String? error = await widget.messageProvider.delete(
//                     message: widget.message,
//                   );
//                   if (error != null) {
//                     if (!mounted) return;
//                     showMessage(context, error, false);
//                     return;
//                   }
//                   Navigator.of(context).pop();
//                 },
//                 icon: const Icon(
//                   Icons.delete,
//                   color: kRedColor,
//                   size: 30,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
//
// class PdfDialog extends StatefulWidget {
//   final ChatMessageProvider messageProvider;
//   final ChatMessageModel message;
//   final String file;
//
//   const PdfDialog({
//     required this.messageProvider,
//     required this.message,
//     this.file = '',
//     super.key,
//   });
//
//   @override
//   State<PdfDialog> createState() => _PdfDialogState();
// }
//
// class _PdfDialogState extends State<PdfDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.topCenter,
//       children: [
//         Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Expanded(
//               child: InteractiveViewer(
//                 minScale: 0.1,
//                 maxScale: 5,
//                 child: SfPdfViewer.network(
//                   widget.file == ''
//                       ? widget.message.image
//                       : File(widget.file).path,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Material(
//               elevation: 8,
//               borderRadius: BorderRadius.circular(100),
//               color: kWhiteColor,
//               child: IconButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 icon: const FaIcon(
//                   FontAwesomeIcons.xmark,
//                   color: kBlackColor,
//                   size: 30,
//                 ),
//               ),
//             ),
//             Material(
//               elevation: 8,
//               borderRadius: BorderRadius.circular(100),
//               color: kWhiteColor,
//               child: IconButton(
//                 onPressed: () async {
//                   String? error = await widget.messageProvider.delete(
//                     message: widget.message,
//                   );
//                   if (error != null) {
//                     if (!mounted) return;
//                     showMessage(context, error, false);
//                     return;
//                   }
//                   Navigator.of(context).pop();
//                 },
//                 icon: const FaIcon(
//                   FontAwesomeIcons.trash,
//                   color: kRedColor,
//                   size: 30,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

class SearchKeywordDialog extends StatefulWidget {
  final Function() getKeyword;

  const SearchKeywordDialog({
    required this.getKeyword,
    super.key,
  });

  @override
  State<SearchKeywordDialog> createState() => _SearchKeywordDialogState();
}

class _SearchKeywordDialogState extends State<SearchKeywordDialog> {
  TextEditingController keywordController = TextEditingController();

  void _getKeyword() async {
    keywordController = TextEditingController(
      text: await getPrefsString('keyword') ?? '',
    );
    setState(() {});
  }

  @override
  void initState() {
    _getKeyword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: keywordController,
            textInputType: TextInputType.text,
            maxLines: 1,
          ),
        ],
      ),
      actions: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: '閉じる',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '検索する',
          labelColor: kWhiteColor,
          backgroundColor: kLightBlueColor,
          onPressed: () async {
            await setPrefsString('keyword', keywordController.text);
            widget.getKeyword();
            if (!mounted) return;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class ChatUsersDialog extends StatefulWidget {
  final ChatModel chat;

  const ChatUsersDialog({
    required this.chat,
    super.key,
  });

  @override
  State<ChatUsersDialog> createState() => _ChatUsersDialogState();
}

class _ChatUsersDialogState extends State<ChatUsersDialog> {
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
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(color: kBorderColor),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: users.map((user) {
              return Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: kBorderColor)),
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

class ReadUsersDialog extends StatefulWidget {
  final List<ReadUserModel> readUsers;

  const ReadUsersDialog({
    required this.readUsers,
    super.key,
  });

  @override
  State<ReadUsersDialog> createState() => _ReadUsersDialogState();
}

class _ReadUsersDialogState extends State<ReadUsersDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(color: kBorderColor),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.readUsers.map((readUser) {
              return Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: kBorderColor)),
                ),
                child: ListTile(
                  title: Text(readUser.userName),
                  trailing: Text(
                    dateText('yyyy/MM/dd HH:mm', readUser.createdAt),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
