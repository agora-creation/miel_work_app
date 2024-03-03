import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/notice.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/notice_detail.dart';
import 'package:miel_work_app/services/notice.dart';
import 'package:miel_work_app/widgets/custom_notice_list.dart';

class NoticeScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const NoticeScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  NoticeService noticeService = NoticeService();

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
        title: const Text(
          'お知らせ一覧',
          style: TextStyle(color: kBlackColor),
        ),
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: noticeService.streamList(
          organizationId: widget.loginProvider.organization?.id,
        ),
        builder: (context, snapshot) {
          List<NoticeModel> notices = [];
          if (snapshot.hasData) {
            for (DocumentSnapshot<Map<String, dynamic>> doc
                in snapshot.data!.docs) {
              NoticeModel notice = NoticeModel.fromSnapshot(doc);
              OrganizationGroupModel? group = widget.homeProvider.currentGroup;
              if (group == null) {
                notices.add(notice);
              } else if (notice.groupId == group.id || notice.groupId == '') {
                notices.add(notice);
              }
            }
          }
          return ListView.builder(
            itemCount: notices.length,
            itemBuilder: (context, index) {
              NoticeModel notice = notices[index];
              return CustomNoticeList(
                notice: notice,
                onTap: () => pushScreen(
                  context,
                  NoticeDetailScreen(notice: notice),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: widget.loginProvider.isAdmin()
          ? FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add, color: kWhiteColor),
            )
          : Container(),
    );
  }
}
