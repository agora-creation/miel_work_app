import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/apply.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/apply_add.dart';
import 'package:miel_work_app/screens/apply_detail.dart';
import 'package:miel_work_app/services/apply.dart';
import 'package:miel_work_app/services/config.dart';
import 'package:miel_work_app/widgets/apply_list.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:page_transition/page_transition.dart';

class ApplyScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ApplyScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  ApplyService applyService = ApplyService();
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kWhiteColor,
          title: const Text(
            '社内申請',
            style: TextStyle(color: kBlackColor),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
            ),
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
          bottom: const TabBar(
            tabs: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('承認待ち', style: TextStyle(fontSize: 18)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('承認済み', style: TextStyle(fontSize: 18)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('否決', style: TextStyle(fontSize: 18)),
              ),
            ],
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 5, color: kBlueColor),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          shape: Border(bottom: BorderSide(color: kBorderColor)),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: applyService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  searchStart: searchStart,
                  searchEnd: searchEnd,
                  approval: [0],
                ),
                builder: (context, snapshot) {
                  List<ApplyModel> applies = [];
                  if (snapshot.hasData) {
                    applies = applyService.generateList(
                      data: snapshot.data,
                      currentGroup: widget.homeProvider.currentGroup,
                    );
                  }
                  if (applies.isEmpty) {
                    return const Center(child: Text('申請はありません'));
                  }
                  return ListView.builder(
                    itemCount: applies.length,
                    itemBuilder: (context, index) {
                      ApplyModel apply = applies[index];
                      return ApplyList(
                        apply: apply,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: ApplyDetailScreen(
                                loginProvider: widget.loginProvider,
                                homeProvider: widget.homeProvider,
                                apply: apply,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: applyService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  searchStart: searchStart,
                  searchEnd: searchEnd,
                  approval: [1],
                ),
                builder: (context, snapshot) {
                  List<ApplyModel> applies = [];
                  if (snapshot.hasData) {
                    applies = applyService.generateList(
                      data: snapshot.data,
                      currentGroup: widget.homeProvider.currentGroup,
                    );
                  }
                  if (applies.isEmpty) {
                    return const Center(child: Text('申請はありません'));
                  }
                  return ListView.builder(
                    itemCount: applies.length,
                    itemBuilder: (context, index) {
                      ApplyModel apply = applies[index];
                      return ApplyList(
                        apply: apply,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: ApplyDetailScreen(
                                loginProvider: widget.loginProvider,
                                homeProvider: widget.homeProvider,
                                apply: apply,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: applyService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  searchStart: searchStart,
                  searchEnd: searchEnd,
                  approval: [9],
                ),
                builder: (context, snapshot) {
                  List<ApplyModel> applies = [];
                  if (snapshot.hasData) {
                    applies = applyService.generateList(
                      data: snapshot.data,
                      currentGroup: widget.homeProvider.currentGroup,
                    );
                  }
                  if (applies.isEmpty) {
                    return const Center(child: Text('申請はありません'));
                  }
                  return ListView.builder(
                    itemCount: applies.length,
                    itemBuilder: (context, index) {
                      ApplyModel apply = applies[index];
                      return ApplyList(
                        apply: apply,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: ApplyDetailScreen(
                                loginProvider: widget.loginProvider,
                                homeProvider: widget.homeProvider,
                                apply: apply,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: ApplyAddScreen(
                  loginProvider: widget.loginProvider,
                  homeProvider: widget.homeProvider,
                ),
              ),
            );
          },
          icon: const Icon(
            Icons.add,
            color: kWhiteColor,
          ),
          label: const Text(
            '新規申請',
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
