import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/comment.dart';
import 'package:miel_work_app/models/notice.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/providers/chat_message.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/notice.dart';
import 'package:miel_work_app/screens/notice_mod.dart';
import 'package:miel_work_app/services/notice.dart';
import 'package:miel_work_app/widgets/comment_list.dart';
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/file_link.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/form_value.dart';
import 'package:miel_work_app/widgets/image_detail_dialog.dart';
import 'package:miel_work_app/widgets/pdf_detail_dialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticeDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final NoticeModel notice;

  const NoticeDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.notice,
    super.key,
  });

  @override
  State<NoticeDetailScreen> createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends State<NoticeDetailScreen> {
  NoticeService noticeService = NoticeService();
  List<CommentModel> comments = [];

  void _reloadComments() async {
    NoticeModel? tmpNotice = await noticeService.selectData(
      id: widget.notice.id,
    );
    if (tmpNotice == null) return;
    comments = tmpNotice.comments;
    setState(() {});
  }

  void _read() async {
    UserModel? user = widget.loginProvider.user;
    List<String> readUserIds = widget.notice.readUserIds;
    if (!readUserIds.contains(user?.id)) {
      readUserIds.add(user?.id ?? '');
      noticeService.update({
        'id': widget.notice.id,
        'readUserIds': readUserIds,
      });
    }
    bool commentNotRead = true;
    List<Map> comments = [];
    if (widget.notice.comments.isNotEmpty) {
      for (final comment in widget.notice.comments) {
        if (comment.readUserIds.contains(user?.id)) {
          commentNotRead = false;
        }
        List<String> commentReadUserIds = comment.readUserIds;
        if (!commentReadUserIds.contains(user?.id)) {
          commentReadUserIds.add(user?.id ?? '');
        }
        comment.readUserIds = commentReadUserIds;
        comments.add(comment.toMap());
      }
    }
    if (commentNotRead) {
      noticeService.update({
        'id': widget.notice.id,
        'comments': comments,
      });
    }
  }

  @override
  void initState() {
    _read();
    comments = widget.notice.comments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final noticeProvider = Provider.of<NoticeProvider>(context);
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
        title: const Text(
          'お知らせ情報の詳細',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => DelNoticeDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                notice: widget.notice,
              ),
            ),
            icon: const FaIcon(
              FontAwesomeIcons.trash,
              color: kRedColor,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: NoticeModScreen(
                    loginProvider: widget.loginProvider,
                    homeProvider: widget.homeProvider,
                    notice: widget.notice,
                  ),
                ),
              );
            },
            icon: const FaIcon(
              FontAwesomeIcons.pen,
              color: kBlueColor,
            ),
          ),
        ],
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '送信日時: ${dateText('yyyy/MM/dd HH:mm', widget.notice.createdAt)}',
                  style: const TextStyle(
                    color: kGreyColor,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '送信者: ${widget.notice.createdUserName}',
                  style: const TextStyle(
                    color: kGreyColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                FormLabel(
                  'タイトル',
                  child: FormValue(widget.notice.title),
                ),
                const SizedBox(height: 8),
                FormLabel(
                  'お知らせ内容',
                  child: FormValue(widget.notice.content),
                ),
                const SizedBox(height: 8),
                widget.notice.file != ''
                    ? FormLabel(
                        '添付ファイル',
                        child: FileLink(
                          file: widget.notice.file,
                          fileExt: widget.notice.fileExt,
                          onTap: () async {
                            String ext = widget.notice.fileExt;
                            if (imageExtensions.contains(ext)) {
                              showDialog(
                                context: context,
                                builder: (context) => ImageDetailDialog(
                                  File(widget.notice.file).path,
                                  onPressedClose: () => Navigator.pop(context),
                                ),
                              );
                            }
                            if (pdfExtensions.contains(ext)) {
                              showDialog(
                                context: context,
                                builder: (context) => PdfDetailDialog(
                                  File(widget.notice.file).path,
                                  onPressedClose: () => Navigator.pop(context),
                                ),
                              );
                            }
                            if (etcExtensions.contains(ext)) {
                              Uri url = Uri.parse(widget.notice.file);
                              await launchUrl(url);
                            }
                          },
                        ),
                      )
                    : Container(),
                const SizedBox(height: 8),
                Container(
                  color: kGreyColor.withOpacity(0.2),
                  padding: const EdgeInsets.all(16),
                  child: FormLabel(
                    '社内コメント',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        comments.isNotEmpty
                            ? Column(
                                children: comments.map((comment) {
                                  return CommentList(comment: comment);
                                }).toList(),
                              )
                            : const ListTile(title: Text('コメントがありません')),
                        const SizedBox(height: 8),
                        CustomButton(
                          type: ButtonSizeType.sm,
                          label: 'コメント追加',
                          labelColor: kWhiteColor,
                          backgroundColor: kBlueColor,
                          onPressed: () {
                            TextEditingController commentContentController =
                                TextEditingController();
                            showDialog(
                              context: context,
                              builder: (context) => CustomAlertDialog(
                                content: SizedBox(
                                  width: 600,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 8),
                                        CustomTextField(
                                          controller: commentContentController,
                                          textInputType:
                                              TextInputType.multiline,
                                          maxLines: null,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  CustomButton(
                                    type: ButtonSizeType.sm,
                                    label: 'キャンセル',
                                    labelColor: kWhiteColor,
                                    backgroundColor: kGreyColor,
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  CustomButton(
                                    type: ButtonSizeType.sm,
                                    label: '追記する',
                                    labelColor: kWhiteColor,
                                    backgroundColor: kBlueColor,
                                    onPressed: () async {
                                      String? error =
                                          await noticeProvider.addComment(
                                        organization:
                                            widget.loginProvider.organization,
                                        notice: widget.notice,
                                        content: commentContentController.text,
                                        loginUser: widget.loginProvider.user,
                                      );
                                      String content = '''
お知らせの「${widget.notice.title}」に、社内コメントを追記しました。
コメント内容:
${commentContentController.text}
                                    ''';
                                      error = await messageProvider.sendComment(
                                        organization:
                                            widget.loginProvider.organization,
                                        content: content,
                                        loginUser: widget.loginProvider.user,
                                      );
                                      if (error != null) {
                                        if (!mounted) return;
                                        showMessage(context, error, false);
                                        return;
                                      }
                                      _reloadComments();
                                      if (!mounted) return;
                                      showMessage(
                                          context, '社内コメントが追記されました', true);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
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

class DelNoticeDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final NoticeModel notice;

  const DelNoticeDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.notice,
    super.key,
  });

  @override
  State<DelNoticeDialog> createState() => _DelNoticeDialogState();
}

class _DelNoticeDialogState extends State<DelNoticeDialog> {
  @override
  Widget build(BuildContext context) {
    final noticeProvider = Provider.of<NoticeProvider>(context);
    return CustomAlertDialog(
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            Text(
              '本当に削除しますか？',
              style: TextStyle(color: kRedColor),
            ),
          ],
        ),
      ),
      actions: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '削除する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            String? error = await noticeProvider.delete(
              notice: widget.notice,
              loginUser: widget.loginProvider.user,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, 'お知らせが削除されました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
