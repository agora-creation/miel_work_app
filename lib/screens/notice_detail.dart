import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/notice.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/notice_mod.dart';
import 'package:miel_work_app/services/notice.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/form_value.dart';
import 'package:miel_work_app/widgets/link_text.dart';
import 'package:page_transition/page_transition.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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

  void _init() async {
    UserModel? user = widget.loginProvider.user;
    List<String> readUserIds = widget.notice.readUserIds;
    if (!readUserIds.contains(user?.id)) {
      readUserIds.add(user?.id ?? '');
      noticeService.update({
        'id': widget.notice.id,
        'readUserIds': readUserIds,
      });
    }
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          'お知らせ詳細',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
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
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateText('yyyy/MM/dd HH:mm', widget.notice.createdAt),
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
              FormLabel(
                '添付ファイル',
                child: widget.notice.file != ''
                    ? LinkText(
                        label: '確認する',
                        color: kBlueColor,
                        onTap: () {
                          String ext = widget.notice.fileExt;
                          if (imageExtensions.contains(ext)) {
                            showDialog(
                              context: context,
                              builder: (context) => ImageDialog(
                                file: widget.notice.file,
                              ),
                            );
                          }
                          if (pdfExtensions.contains(ext)) {
                            showDialog(
                              context: context,
                              builder: (context) => PdfDialog(
                                file: widget.notice.file,
                              ),
                            );
                          }
                        },
                      )
                    : Container(),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageDialog extends StatelessWidget {
  final String file;

  const ImageDialog({
    required this.file,
    super.key,
  });

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
                child: Image.network(File(file).path),
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
                icon: const FaIcon(
                  FontAwesomeIcons.xmark,
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

class PdfDialog extends StatelessWidget {
  final String file;

  const PdfDialog({
    required this.file,
    super.key,
  });

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
                child: SfPdfViewer.network(File(file).path),
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
                icon: const FaIcon(
                  FontAwesomeIcons.xmark,
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
