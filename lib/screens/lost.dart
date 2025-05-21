import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/lost.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/lost_add.dart';
import 'package:miel_work_app/screens/lost_detail.dart';
import 'package:miel_work_app/services/config.dart';
import 'package:miel_work_app/services/lost.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/lost_card.dart';
import 'package:miel_work_app/widgets/search_field.dart';
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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: DefaultTabController(
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
                icon: const FaIcon(
                  FontAwesomeIcons.xmark,
                  color: kBlackColor,
                ),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
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
                  child: Text('破棄済', style: TextStyle(fontSize: 18)),
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
            child: Column(
              children: [
                SearchField(
                  controller: keywordController,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: lostService.streamList(
                          organizationId: widget.loginProvider.organization?.id,
                          searchStatus: [0],
                        ),
                        builder: (context, snapshot) {
                          List<LostModel> losts = [];
                          if (snapshot.hasData) {
                            losts = lostService.generateList(
                              data: snapshot.data,
                              keyword: keywordController.text,
                            );
                          }
                          if (losts.isEmpty) {
                            return const Center(child: Text('落とし物はありません'));
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: losts.length,
                            itemBuilder: (context, index) {
                              LostModel lost = losts[index];
                              return LostCard(
                                lost: lost,
                                user: widget.loginProvider.user,
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: LostDetailScreen(
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
                          searchStatus: [1],
                        ),
                        builder: (context, snapshot) {
                          List<LostModel> losts = [];
                          if (snapshot.hasData) {
                            losts = lostService.generateList(
                              data: snapshot.data,
                              keyword: keywordController.text,
                            );
                          }
                          if (losts.isEmpty) {
                            return const Center(child: Text('落とし物はありません'));
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: losts.length,
                            itemBuilder: (context, index) {
                              LostModel lost = losts[index];
                              return LostCard(
                                lost: lost,
                                user: widget.loginProvider.user,
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: LostDetailScreen(
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
                          searchStatus: [9],
                        ),
                        builder: (context, snapshot) {
                          List<LostModel> losts = [];
                          if (snapshot.hasData) {
                            losts = lostService.generateList(
                              data: snapshot.data,
                              keyword: keywordController.text,
                            );
                          }
                          if (losts.isEmpty) {
                            return const Center(child: Text('落とし物はありません'));
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: losts.length,
                            itemBuilder: (context, index) {
                              LostModel lost = losts[index];
                              return LostCard(
                                lost: lost,
                                user: widget.loginProvider.user,
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: LostDetailScreen(
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
      ),
    );
  }
}
