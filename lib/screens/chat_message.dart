import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/chat.dart';
import 'package:miel_work_app/models/chat_message.dart';
import 'package:miel_work_app/models/read_user.dart';
import 'package:miel_work_app/models/reply_source.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/providers/chat_message.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/services/chat_message.dart';
import 'package:miel_work_app/services/config.dart';
import 'package:miel_work_app/services/user.dart';
import 'package:miel_work_app/widgets/custom_button_sm.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/message_form_field.dart';
import 'package:miel_work_app/widgets/message_list.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ChatMessageScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final ChatModel chat;

  const ChatMessageScreen({
    required this.loginProvider,
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
    super.initState();
    _init();
    _getKeyword();
  }

  @override
  Widget build(BuildContext context) {
    final messageProvider = Provider.of<ChatMessageProvider>(context);
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
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => SearchKeywordDialog(
                getKeyword: _getKeyword,
              ),
            ),
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => ChatUsersDialog(
                chat: widget.chat,
              ),
            ),
            icon: const Icon(Icons.groups),
          ),
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
                                builder: (context) => ImageDialog(
                                  messageProvider: messageProvider,
                                  message: message,
                                ),
                              ),
                              onTapFile: () {
                                String ext = message.fileExt;
                                if (imageExtensions.contains(ext)) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => ImageDialog(
                                      messageProvider: messageProvider,
                                      message: message,
                                      file: message.file,
                                    ),
                                  );
                                }
                                if (pdfExtensions.contains(ext)) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => PdfDialog(
                                      messageProvider: messageProvider,
                                      message: message,
                                      file: message.file,
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
    );
  }
}

class ImageDialog extends StatefulWidget {
  final ChatMessageProvider messageProvider;
  final ChatMessageModel message;
  final String file;

  const ImageDialog({
    required this.messageProvider,
    required this.message,
    this.file = '',
    super.key,
  });

  @override
  State<ImageDialog> createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: InteractiveViewer(
                minScale: 0.1,
                maxScale: 5,
                child: Image.network(
                  widget.file == ''
                      ? widget.message.image
                      : File(widget.file).path,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Material(
              color: Colors.transparent,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close,
                  color: kWhiteColor,
                  size: 30,
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: IconButton(
                onPressed: () async {
                  String? error = await widget.messageProvider.delete(
                    message: widget.message,
                  );
                  if (error != null) {
                    if (!mounted) return;
                    showMessage(context, error, false);
                    return;
                  }
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.delete,
                  color: kWhiteColor,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PdfDialog extends StatefulWidget {
  final ChatMessageProvider messageProvider;
  final ChatMessageModel message;
  final String file;

  const PdfDialog({
    required this.messageProvider,
    required this.message,
    this.file = '',
    super.key,
  });

  @override
  State<PdfDialog> createState() => _PdfDialogState();
}

class _PdfDialogState extends State<PdfDialog> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: InteractiveViewer(
                minScale: 0.1,
                maxScale: 5,
                child: SfPdfViewer.network(
                  widget.file == ''
                      ? widget.message.image
                      : File(widget.file).path,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Material(
              color: Colors.transparent,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close,
                  color: kWhiteColor,
                  size: 30,
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: IconButton(
                onPressed: () async {
                  String? error = await widget.messageProvider.delete(
                    message: widget.message,
                  );
                  if (error != null) {
                    if (!mounted) return;
                    showMessage(context, error, false);
                    return;
                  }
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.delete,
                  color: kWhiteColor,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

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
    super.initState();
    _getKeyword();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      title: const Text(
        'キーワード検索',
        style: TextStyle(fontSize: 16),
      ),
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
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        CustomButtonSm(
          label: '閉じる',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButtonSm(
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
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      titlePadding: const EdgeInsets.all(8),
      title: const Text(
        '参加スタッフ',
        style: TextStyle(fontSize: 14),
      ),
      content: Container(
        decoration: const BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(color: kGrey600Color),
          ),
        ),
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
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      titlePadding: const EdgeInsets.all(8),
      title: const Text(
        '既読スタッフ',
        style: TextStyle(fontSize: 14),
      ),
      content: Container(
        decoration: const BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(color: kGrey600Color),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.readUsers.map((readUser) {
              return Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: kGrey600Color)),
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
