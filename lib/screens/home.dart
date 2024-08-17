import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/chat_message.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/apply.dart';
import 'package:miel_work_app/screens/chat.dart';
import 'package:miel_work_app/screens/group.dart';
import 'package:miel_work_app/screens/loan.dart';
import 'package:miel_work_app/screens/lost.dart';
import 'package:miel_work_app/screens/notice.dart';
import 'package:miel_work_app/screens/plan.dart';
import 'package:miel_work_app/screens/problem.dart';
import 'package:miel_work_app/screens/report.dart';
import 'package:miel_work_app/screens/user.dart';
import 'package:miel_work_app/screens/user_setting.dart';
import 'package:miel_work_app/screens/work.dart';
import 'package:miel_work_app/services/apply.dart';
import 'package:miel_work_app/services/chat_message.dart';
import 'package:miel_work_app/services/loan.dart';
import 'package:miel_work_app/services/lost.dart';
import 'package:miel_work_app/services/notice.dart';
import 'package:miel_work_app/services/problem.dart';
import 'package:miel_work_app/widgets/animation_background.dart';
import 'package:miel_work_app/widgets/connection_card.dart';
import 'package:miel_work_app/widgets/custom_appbar.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/group_select_card.dart';
import 'package:miel_work_app/widgets/home_icon_card.dart';
import 'package:miel_work_app/widgets/home_plan_card.dart';
import 'package:miel_work_app/widgets/home_problem_card.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NoticeService noticeService = NoticeService();
  ChatMessageService messageService = ChatMessageService();
  ProblemService problemService = ProblemService();
  ApplyService applyService = ApplyService();
  LostService lostService = LostService();
  LoanService loanService = LoanService();

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final homeProvider = Provider.of<HomeProvider>(context);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          const AnimationBackground(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppbar(
                  loginProvider: loginProvider,
                  actions: [
                    IconButton(
                      onPressed: () => showBottomUpScreen(
                        context,
                        UserSettingScreen(
                          loginProvider: loginProvider,
                          homeProvider: homeProvider,
                        ),
                      ),
                      icon: const FaIcon(FontAwesomeIcons.gear),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const ConnectionCard(),
                          GroupSelectCard(
                            loginProvider: loginProvider,
                            homeProvider: homeProvider,
                          ),
                          GridView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            gridDelegate: kHome2Grid,
                            children: [
                              StreamBuilder<
                                  QuerySnapshot<Map<String, dynamic>>>(
                                stream: noticeService.streamList(
                                  organizationId:
                                      loginProvider.organization?.id,
                                  searchStart: null,
                                  searchEnd: null,
                                ),
                                builder: (context, snapshot) {
                                  bool alert = false;
                                  if (snapshot.hasData) {
                                    alert = noticeService.checkAlert(
                                      data: snapshot.data,
                                      currentGroup: homeProvider.currentGroup,
                                      user: loginProvider.user,
                                    );
                                  }
                                  return HomeIconCard(
                                    icon: FontAwesomeIcons.solidBell,
                                    label: 'お知らせ',
                                    color: kBlackColor,
                                    backgroundColor: kWhiteColor,
                                    alert: alert,
                                    onTap: () => showBottomUpScreen(
                                      context,
                                      NoticeScreen(
                                        loginProvider: loginProvider,
                                        homeProvider: homeProvider,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              StreamBuilder<
                                  QuerySnapshot<Map<String, dynamic>>>(
                                stream: messageService.streamListUnread(
                                  organizationId:
                                      loginProvider.organization?.id,
                                ),
                                builder: (context, snapshot) {
                                  bool alert = false;
                                  if (snapshot.hasData) {
                                    List<ChatMessageModel> messages =
                                        messageService.generateListUnread(
                                      data: snapshot.data,
                                      currentGroup: homeProvider.currentGroup,
                                      loginUser: loginProvider.user,
                                    );
                                    if (messages.isNotEmpty) {
                                      alert = true;
                                    }
                                  }
                                  return HomeIconCard(
                                    icon: FontAwesomeIcons.solidComments,
                                    label: 'チャット',
                                    color: kBlackColor,
                                    backgroundColor: kWhiteColor,
                                    alert: alert,
                                    onTap: () => showBottomUpScreen(
                                      context,
                                      ChatScreen(
                                        loginProvider: loginProvider,
                                        homeProvider: homeProvider,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          HomePlanCard(
                            loginProvider: loginProvider,
                            homeProvider: homeProvider,
                            onTap: () => showBottomUpScreen(
                              context,
                              PlanScreen(
                                loginProvider: loginProvider,
                                homeProvider: homeProvider,
                              ),
                            ),
                          ),
                          HomeProblemCard(
                            loginProvider: loginProvider,
                            homeProvider: homeProvider,
                            onTap: () => showBottomUpScreen(
                              context,
                              ProblemScreen(
                                loginProvider: loginProvider,
                                homeProvider: homeProvider,
                              ),
                            ),
                          ),
                          GridView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            gridDelegate: kHome2Grid,
                            children: [
                              StreamBuilder<
                                  QuerySnapshot<Map<String, dynamic>>>(
                                stream: lostService.streamList(
                                  organizationId:
                                      loginProvider.organization?.id,
                                  searchStart: null,
                                  searchEnd: null,
                                  searchStatus: [0],
                                ),
                                builder: (context, snapshot) {
                                  bool alert = false;
                                  if (snapshot.hasData) {
                                    alert = lostService.checkAlert(
                                      data: snapshot.data,
                                    );
                                  }
                                  return HomeIconCard(
                                    icon: FontAwesomeIcons.personCircleQuestion,
                                    label: '落とし物',
                                    color: kBlackColor,
                                    backgroundColor: kWhiteColor,
                                    alert: alert,
                                    alertMessage: '保管中',
                                    onTap: () => showBottomUpScreen(
                                      context,
                                      LostScreen(
                                        loginProvider: loginProvider,
                                        homeProvider: homeProvider,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              StreamBuilder<
                                  QuerySnapshot<Map<String, dynamic>>>(
                                stream: applyService.streamList(
                                  organizationId:
                                      loginProvider.organization?.id,
                                  searchStart: null,
                                  searchEnd: null,
                                  approval: [0],
                                ),
                                builder: (context, snapshot) {
                                  bool alert = false;
                                  if (snapshot.hasData) {
                                    alert = applyService.checkAlert(
                                      data: snapshot.data,
                                    );
                                  }
                                  return HomeIconCard(
                                    icon: FontAwesomeIcons.filePen,
                                    label: '各種申請',
                                    color: kBlackColor,
                                    backgroundColor: kWhiteColor,
                                    alert: alert,
                                    alertMessage: '承認待ちあり',
                                    onTap: () => showBottomUpScreen(
                                      context,
                                      ApplyScreen(
                                        loginProvider: loginProvider,
                                        homeProvider: homeProvider,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          GridView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            gridDelegate: kHome3Grid,
                            children: [
                              HomeIconCard(
                                icon: FontAwesomeIcons.businessTime,
                                iconSize: 42,
                                label: '勤怠打刻',
                                labelFontSize: 16,
                                color: kBlackColor,
                                backgroundColor: kWhiteColor,
                                onTap: () => showBottomUpScreen(
                                  context,
                                  WorkScreen(
                                    loginProvider: loginProvider,
                                    homeProvider: homeProvider,
                                  ),
                                ),
                              ),
                              HomeIconCard(
                                icon: FontAwesomeIcons.clipboardCheck,
                                iconSize: 42,
                                label: '業務日報',
                                labelFontSize: 16,
                                color: kBlackColor,
                                backgroundColor: kWhiteColor,
                                onTap: () => showBottomUpScreen(
                                  context,
                                  ReportScreen(
                                    loginProvider: loginProvider,
                                    homeProvider: homeProvider,
                                  ),
                                ),
                              ),
                              StreamBuilder<
                                  QuerySnapshot<Map<String, dynamic>>>(
                                stream: loanService.streamList(
                                  organizationId:
                                      loginProvider.organization?.id,
                                  searchStart: null,
                                  searchEnd: null,
                                  searchStatus: [0],
                                ),
                                builder: (context, snapshot) {
                                  bool alert = false;
                                  if (snapshot.hasData) {
                                    alert = loanService.checkAlert(
                                      data: snapshot.data,
                                    );
                                  }
                                  return HomeIconCard(
                                    icon: FontAwesomeIcons.rightLeft,
                                    iconSize: 42,
                                    label: '貸出／返却',
                                    labelFontSize: 16,
                                    color: kBlackColor,
                                    backgroundColor: kWhiteColor,
                                    alert: alert,
                                    alertMessage: '貸出中',
                                    onTap: () => showBottomUpScreen(
                                      context,
                                      LoanScreen(
                                        loginProvider: loginProvider,
                                        homeProvider: homeProvider,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              HomeIconCard(
                                icon: FontAwesomeIcons.bolt,
                                iconSize: 42,
                                label: 'メーター検針',
                                labelFontSize: 16,
                                color: kBlackColor,
                                backgroundColor: kWhiteColor,
                                onTap: () async {
                                  Uri url =
                                      Uri.parse('https://hirome.co.jp/meter/');
                                  if (!await launchUrl(url)) {
                                    throw Exception('Could not launch $url');
                                  }
                                },
                              ),
                              loginProvider.user?.admin == true
                                  ? HomeIconCard(
                                      icon: FontAwesomeIcons.usersRectangle,
                                      iconSize: 42,
                                      label: 'グループ一覧',
                                      labelFontSize: 16,
                                      color: kWhiteColor,
                                      backgroundColor: kDisabledColor,
                                      onTap: () => showBottomUpScreen(
                                        context,
                                        GroupScreen(
                                          loginProvider: loginProvider,
                                          homeProvider: homeProvider,
                                        ),
                                      ),
                                    )
                                  : Container(),
                              loginProvider.user?.admin == true
                                  ? HomeIconCard(
                                      icon: FontAwesomeIcons.users,
                                      iconSize: 42,
                                      label: 'スタッフ一覧',
                                      labelFontSize: 16,
                                      color: kWhiteColor,
                                      backgroundColor: kDisabledColor,
                                      onTap: () => showBottomUpScreen(
                                        context,
                                        UserScreen(
                                          loginProvider: loginProvider,
                                          homeProvider: homeProvider,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomFooter(
        loginProvider: loginProvider,
        homeProvider: homeProvider,
      ),
    );
  }
}
