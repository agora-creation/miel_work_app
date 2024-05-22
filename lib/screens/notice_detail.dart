import 'dart:io';

import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/notice.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/notice_mod.dart';
import 'package:miel_work_app/services/notice.dart';
import 'package:miel_work_app/widgets/link_text.dart';
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
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
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
          widget.notice.title,
          style: const TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            onPressed: () => pushScreen(
              context,
              NoticeModScreen(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                notice: widget.notice,
              ),
            ),
            icon: const Icon(Icons.edit, color: kBlueColor),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  dateText('yyyy/MM/dd HH:mm', widget.notice.createdAt),
                  style: const TextStyle(color: kGreyColor),
                ),
              ),
              const SizedBox(height: 4),
              Text(widget.notice.content),
              const SizedBox(height: 16),
              widget.notice.file != ''
                  ? LinkText(
                      label: '添付ファイル',
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
                icon: const Icon(
                  Icons.close,
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
                icon: const Icon(
                  Icons.close,
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
