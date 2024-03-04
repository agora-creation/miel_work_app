import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/notice.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/services/notice.dart';

class NoticeDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final NoticeModel notice;

  const NoticeDetailScreen({
    required this.loginProvider,
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
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(widget.notice.content),
          const SizedBox(height: 8),
          const Divider(height: 1, color: kGrey300Color),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              dateText('yyyy/MM/dd HH:mm', widget.notice.createdAt),
              style: const TextStyle(color: kGreyColor),
            ),
          ),
        ],
      ),
    );
  }
}
