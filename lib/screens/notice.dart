import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/notice.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/notice_add.dart';
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
  DateTime? searchStart;
  DateTime? searchEnd;

  @override
  Widget build(BuildContext context) {
    String appBarTitle = '';
    if (widget.homeProvider.currentGroup != null) {
      appBarTitle = '${widget.homeProvider.currentGroup?.name}のお知らせ';
    } else {
      appBarTitle = '全てのお知らせ';
    }
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
          appBarTitle,
          style: const TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              var selected = await showDataRangePickerDialog(
                context: context,
                startValue: searchStart,
                endValue: searchEnd,
              );
              if (selected != null &&
                  selected.first != null &&
                  selected.last != null) {
                var diff = selected.last!.difference(selected.first!);
                int diffDays = diff.inDays;
                if (diffDays > 31) {
                  if (!mounted) return;
                  showMessage(context, '1ヵ月以上の範囲が選択されています', false);
                  return;
                }
                searchStart = selected.first;
                searchEnd = selected.last;
                setState(() {});
              }
            },
            icon: const Icon(Icons.date_range, color: kBlueColor),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: noticeService.streamList(
          organizationId: widget.loginProvider.organization?.id,
          searchStart: searchStart,
          searchEnd: searchEnd,
        ),
        builder: (context, snapshot) {
          List<NoticeModel> notices = [];
          if (snapshot.hasData) {
            notices = noticeService.generateList(
              data: snapshot.data,
              currentGroup: widget.homeProvider.currentGroup,
            );
          }
          if (notices.isEmpty) {
            return const Center(child: Text('お知らせはありません'));
          }
          return ListView.builder(
            itemCount: notices.length,
            itemBuilder: (context, index) {
              NoticeModel notice = notices[index];
              return CustomNoticeList(
                notice: notice,
                user: widget.loginProvider.user,
                onTap: () => pushScreen(
                  context,
                  NoticeDetailScreen(
                    loginProvider: widget.loginProvider,
                    homeProvider: widget.homeProvider,
                    notice: notice,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: widget.loginProvider.user?.admin == true
          ? FloatingActionButton.extended(
              onPressed: () => pushScreen(
                context,
                NoticeAddScreen(
                  loginProvider: widget.loginProvider,
                  homeProvider: widget.homeProvider,
                ),
              ),
              icon: const Icon(
                Icons.add,
                color: kWhiteColor,
              ),
              label: const Text(
                '新規追加',
                style: TextStyle(color: kWhiteColor),
              ),
            )
          : null,
    );
  }
}
