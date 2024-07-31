import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/notice.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/notice_add.dart';
import 'package:miel_work_app/screens/notice_detail.dart';
import 'package:miel_work_app/services/config.dart';
import 'package:miel_work_app/services/notice.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/notice_list.dart';
import 'package:page_transition/page_transition.dart';

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

  void _init() async {
    await ConfigService().checkReview();
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

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
        automaticallyImplyLeading: false,
        backgroundColor: kWhiteColor,
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
            icon: const FaIcon(
              FontAwesomeIcons.calendarDays,
              color: kBlackColor,
            ),
          ),
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.xmark,
              color: kBlackColor,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
        shape: Border(bottom: BorderSide(color: kBorderColor)),
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
              return NoticeList(
                notice: notice,
                user: widget.loginProvider.user,
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: NoticeDetailScreen(
                        loginProvider: widget.loginProvider,
                        homeProvider: widget.homeProvider,
                        notice: notice,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: NoticeAddScreen(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
              ),
            ),
          );
        },
        icon: const FaIcon(
          FontAwesomeIcons.plus,
          color: kWhiteColor,
        ),
        label: const Text(
          '新規追加',
          style: TextStyle(color: kWhiteColor),
        ),
      ),
      bottomNavigationBar: CustomFooter(
        loginProvider: widget.loginProvider,
        homeProvider: widget.homeProvider,
      ),
    );
  }
}
