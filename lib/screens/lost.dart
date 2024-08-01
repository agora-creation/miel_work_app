import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/lost.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/lost_add.dart';
import 'package:miel_work_app/screens/lost_mod.dart';
import 'package:miel_work_app/services/config.dart';
import 'package:miel_work_app/services/lost.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/lost_card.dart';
import 'package:page_transition/page_transition.dart';

class LostScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const LostScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<LostScreen> createState() => _LostScreenState();
}

class _LostScreenState extends State<LostScreen> {
  LostService lostService = LostService();
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
            '落とし物',
            style: TextStyle(color: kBlackColor),
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
          bottom: const TabBar(
            tabs: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('保管中', style: TextStyle(fontSize: 18)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('返却済', style: TextStyle(fontSize: 18)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('破棄', style: TextStyle(fontSize: 18)),
              ),
            ],
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 5, color: kBlueColor),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          shape: Border(bottom: BorderSide(color: kBorderColor)),
        ),
        body: TabBarView(
          children: [
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: lostService.streamList(
                organizationId: widget.loginProvider.organization?.id,
                searchStart: searchStart,
                searchEnd: searchEnd,
                searchStatus: [0],
              ),
              builder: (context, snapshot) {
                List<LostModel> losts = [];
                if (snapshot.hasData) {
                  losts = lostService.generateList(
                    data: snapshot.data,
                  );
                }
                if (losts.isEmpty) {
                  return const Center(child: Text('落とし物はありません'));
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  padding: const EdgeInsets.all(8),
                  itemCount: losts.length,
                  itemBuilder: (context, index) {
                    LostModel lost = losts[index];
                    return LostCard(
                      lost: lost,
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: LostModScreen(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              lost: lost,
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
              stream: lostService.streamList(
                organizationId: widget.loginProvider.organization?.id,
                searchStart: searchStart,
                searchEnd: searchEnd,
                searchStatus: [1],
              ),
              builder: (context, snapshot) {
                List<LostModel> losts = [];
                if (snapshot.hasData) {
                  losts = lostService.generateList(
                    data: snapshot.data,
                  );
                }
                if (losts.isEmpty) {
                  return const Center(child: Text('落とし物はありません'));
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  padding: const EdgeInsets.all(8),
                  itemCount: losts.length,
                  itemBuilder: (context, index) {
                    LostModel lost = losts[index];
                    return LostCard(
                      lost: lost,
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: LostModScreen(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              lost: lost,
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
              stream: lostService.streamList(
                organizationId: widget.loginProvider.organization?.id,
                searchStart: searchStart,
                searchEnd: searchEnd,
                searchStatus: [9],
              ),
              builder: (context, snapshot) {
                List<LostModel> losts = [];
                if (snapshot.hasData) {
                  losts = lostService.generateList(
                    data: snapshot.data,
                  );
                }
                if (losts.isEmpty) {
                  return const Center(child: Text('落とし物はありません'));
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  padding: const EdgeInsets.all(8),
                  itemCount: losts.length,
                  itemBuilder: (context, index) {
                    LostModel lost = losts[index];
                    return LostCard(
                      lost: lost,
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: LostModScreen(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              lost: lost,
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: LostAddScreen(
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
