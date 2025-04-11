import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/request_cycle.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/request_cycle_detail.dart';
import 'package:miel_work_app/services/config.dart';
import 'package:miel_work_app/services/request_cycle.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/request_cycle_list.dart';
import 'package:page_transition/page_transition.dart';

class RequestCycleScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const RequestCycleScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<RequestCycleScreen> createState() => _RequestCycleScreenState();
}

class _RequestCycleScreenState extends State<RequestCycleScreen> {
  RequestCycleService cycleService = RequestCycleService();

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
            '社外申請：自転車置き場使用申込',
            style: TextStyle(color: kBlackColor),
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
                stream: cycleService.streamList(
                  approval: [0],
                ),
                builder: (context, snapshot) {
                  List<RequestCycleModel> cycles = [];
                  if (snapshot.hasData) {
                    cycles = cycleService.generateList(snapshot.data);
                  }
                  if (cycles.isEmpty) {
                    return const Center(child: Text('申請はありません'));
                  }
                  return ListView.builder(
                    itemCount: cycles.length,
                    itemBuilder: (context, index) {
                      RequestCycleModel cycle = cycles[index];
                      return RequestCycleList(
                        cycle: cycle,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: RequestCycleDetailScreen(
                                loginProvider: widget.loginProvider,
                                homeProvider: widget.homeProvider,
                                cycle: cycle,
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
                stream: cycleService.streamList(
                  approval: [1],
                ),
                builder: (context, snapshot) {
                  List<RequestCycleModel> cycles = [];
                  if (snapshot.hasData) {
                    cycles = cycleService.generateList(snapshot.data);
                  }
                  if (cycles.isEmpty) {
                    return const Center(child: Text('申請はありません'));
                  }
                  return ListView.builder(
                    itemCount: cycles.length,
                    itemBuilder: (context, index) {
                      RequestCycleModel cycle = cycles[index];
                      return RequestCycleList(
                        cycle: cycle,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: RequestCycleDetailScreen(
                                loginProvider: widget.loginProvider,
                                homeProvider: widget.homeProvider,
                                cycle: cycle,
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
                stream: cycleService.streamList(
                  approval: [9],
                ),
                builder: (context, snapshot) {
                  List<RequestCycleModel> cycles = [];
                  if (snapshot.hasData) {
                    cycles = cycleService.generateList(snapshot.data);
                  }
                  if (cycles.isEmpty) {
                    return const Center(child: Text('申請はありません'));
                  }
                  return ListView.builder(
                    itemCount: cycles.length,
                    itemBuilder: (context, index) {
                      RequestCycleModel cycle = cycles[index];
                      return RequestCycleList(
                        cycle: cycle,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: RequestCycleDetailScreen(
                                loginProvider: widget.loginProvider,
                                homeProvider: widget.homeProvider,
                                cycle: cycle,
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
        bottomNavigationBar: CustomFooter(
          loginProvider: widget.loginProvider,
          homeProvider: widget.homeProvider,
        ),
      ),
    );
  }
}
