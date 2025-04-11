import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
import 'package:miel_work_app/widgets/search_field.dart';
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
  TextEditingController keywordController = TextEditingController();

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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
              icon: const FaIcon(
                FontAwesomeIcons.xmark,
                color: kBlackColor,
              ),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            ),
          ],
          shape: Border(bottom: BorderSide(color: kBorderColor)),
        ),
        body: SafeArea(
          child: Column(
            children: [
              SearchField(
                controller: keywordController,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: noticeService.streamList(
                    organizationId: widget.loginProvider.organization?.id,
                  ),
                  builder: (context, snapshot) {
                    List<NoticeModel> notices = [];
                    if (snapshot.hasData) {
                      notices = noticeService.generateList(
                        data: snapshot.data,
                        currentGroup: widget.homeProvider.currentGroup,
                        keyword: keywordController.text,
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
                            FocusManager.instance.primaryFocus?.unfocus();
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
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
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
            '追加する',
            style: TextStyle(color: kWhiteColor),
          ),
        ),
        bottomNavigationBar: CustomFooter(
          loginProvider: widget.loginProvider,
          homeProvider: widget.homeProvider,
        ),
      ),
    );
  }
}
