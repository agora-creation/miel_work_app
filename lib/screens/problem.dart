import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/problem.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/problem_add.dart';
import 'package:miel_work_app/screens/problem_detail.dart';
import 'package:miel_work_app/services/config.dart';
import 'package:miel_work_app/services/problem.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/problem_list.dart';
import 'package:page_transition/page_transition.dart';

class ProblemScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ProblemScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ProblemScreen> createState() => _ProblemScreenState();
}

class _ProblemScreenState extends State<ProblemScreen> {
  ProblemService problemService = ProblemService();
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
      length: 2,
      child: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kWhiteColor,
          title: const Text(
            'クレーム／要望',
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
                child: Text('未処理', style: TextStyle(fontSize: 18)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('処理済', style: TextStyle(fontSize: 18)),
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
              stream: problemService.streamList(
                organizationId: widget.loginProvider.organization?.id,
                searchStart: searchStart,
                searchEnd: searchEnd,
                processed: false,
              ),
              builder: (context, snapshot) {
                List<ProblemModel> problems = [];
                if (snapshot.hasData) {
                  problems = problemService.generateList(
                    data: snapshot.data,
                  );
                }
                if (problems.isEmpty) {
                  return const Center(child: Text('クレーム／要望はありません'));
                }
                return ListView.builder(
                  itemCount: problems.length,
                  itemBuilder: (context, index) {
                    ProblemModel problem = problems[index];
                    return ProblemList(
                      problem: problem,
                      user: widget.loginProvider.user,
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: ProblemDetailScreen(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              problem: problem,
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
              stream: problemService.streamList(
                organizationId: widget.loginProvider.organization?.id,
                searchStart: searchStart,
                searchEnd: searchEnd,
                processed: true,
              ),
              builder: (context, snapshot) {
                List<ProblemModel> problems = [];
                if (snapshot.hasData) {
                  problems = problemService.generateList(
                    data: snapshot.data,
                  );
                }
                if (problems.isEmpty) {
                  return const Center(child: Text('クレーム／要望はありません'));
                }
                return ListView.builder(
                  itemCount: problems.length,
                  itemBuilder: (context, index) {
                    ProblemModel problem = problems[index];
                    return ProblemList(
                      problem: problem,
                      user: widget.loginProvider.user,
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: ProblemDetailScreen(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              problem: problem,
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
                child: ProblemAddScreen(
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
