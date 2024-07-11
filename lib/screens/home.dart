import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/chat_message.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/apply_select.dart';
import 'package:miel_work_app/screens/chat.dart';
import 'package:miel_work_app/screens/group.dart';
import 'package:miel_work_app/screens/notice.dart';
import 'package:miel_work_app/screens/plan.dart';
import 'package:miel_work_app/screens/plan_shift.dart';
import 'package:miel_work_app/screens/problem.dart';
import 'package:miel_work_app/screens/user.dart';
import 'package:miel_work_app/screens/user_setting.dart';
import 'package:miel_work_app/services/chat_message.dart';
import 'package:miel_work_app/services/notice.dart';
import 'package:miel_work_app/services/problem.dart';
import 'package:miel_work_app/widgets/animation_background.dart';
import 'package:miel_work_app/widgets/custom_appbar.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/custom_home_icon_card.dart';
import 'package:miel_work_app/widgets/custom_home_plan_card.dart';
import 'package:miel_work_app/widgets/group_select_card.dart';
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

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final homeProvider = Provider.of<HomeProvider>(context);
    return Scaffold(
      backgroundColor: kHomeBackgroundColor,
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
                      icon: const Icon(Icons.settings),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: [
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
                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: noticeService.streamList(
                              organizationId: loginProvider.organization?.id,
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
                              return CustomHomeIconCard(
                                icon: Icons.notifications,
                                label: 'お知らせ',
                                color: kBlackColor,
                                backgroundColor: kWhiteColor,
                                alert: alert,
                                onTap: () => pushScreen(
                                  context,
                                  NoticeScreen(
                                    loginProvider: loginProvider,
                                    homeProvider: homeProvider,
                                  ),
                                ),
                              );
                            },
                          ),
                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: messageService.streamListUnread(
                              organizationId: loginProvider.organization?.id,
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
                              return CustomHomeIconCard(
                                icon: Icons.question_answer,
                                label: 'チャット',
                                color: kBlackColor,
                                backgroundColor: kWhiteColor,
                                alert: alert,
                                onTap: () => pushScreen(
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
                      CustomHomePlanCard(
                        loginProvider: loginProvider,
                        homeProvider: homeProvider,
                        onTap: () => pushScreen(
                          context,
                          PlanScreen(
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
                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: problemService.streamList(
                              organizationId: loginProvider.organization?.id,
                              searchStart: null,
                              searchEnd: null,
                            ),
                            builder: (context, snapshot) {
                              bool alert = false;
                              if (snapshot.hasData) {
                                alert = problemService.checkAlert(
                                  data: snapshot.data,
                                  user: loginProvider.user,
                                );
                              }
                              return CustomHomeIconCard(
                                icon: Icons.sentiment_very_dissatisfied_sharp,
                                label: 'クレーム／要望',
                                color: kBlackColor,
                                backgroundColor: kWhiteColor,
                                alert: alert,
                                onTap: () => pushScreen(
                                  context,
                                  ProblemScreen(
                                    loginProvider: loginProvider,
                                    homeProvider: homeProvider,
                                  ),
                                ),
                              );
                            },
                          ),
                          CustomHomeIconCard(
                            icon: Icons.edit_note,
                            label: '各種申請',
                            color: kBlackColor,
                            backgroundColor: kWhiteColor,
                            onTap: () => pushScreen(
                              context,
                              ApplySelectScreen(
                                loginProvider: loginProvider,
                                homeProvider: homeProvider,
                              ),
                            ),
                          ),
                        ],
                      ),
                      GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        gridDelegate: kHome3Grid,
                        children: [
                          CustomHomeIconCard(
                            icon: Icons.view_timeline,
                            iconSize: 42,
                            label: 'シフト',
                            labelFontSize: 16,
                            color: kBlackColor,
                            backgroundColor: kWhiteColor,
                            onTap: () => pushScreen(
                              context,
                              PlanShiftScreen(
                                loginProvider: loginProvider,
                                homeProvider: homeProvider,
                              ),
                            ),
                          ),
                          CustomHomeIconCard(
                            icon: Icons.device_unknown,
                            iconSize: 42,
                            label: '落とし物',
                            labelFontSize: 16,
                            color: kBlackColor,
                            backgroundColor: kWhiteColor,
                            onTap: () async {
                              Uri url = Uri.parse(
                                  'https://hirome.co.jp/lost/app.php');
                              if (!await launchUrl(url)) {
                                throw Exception('Could not launch $url');
                              }
                            },
                          ),
                          CustomHomeIconCard(
                            icon: Icons.front_hand,
                            iconSize: 42,
                            label: '貸出物',
                            labelFontSize: 16,
                            color: kBlackColor,
                            backgroundColor: kWhiteColor,
                            onTap: () async {
                              Uri url = Uri.parse(
                                  'https://hirome.co.jp/loan/app.php');
                              if (!await launchUrl(url)) {
                                throw Exception('Could not launch $url');
                              }
                            },
                          ),
                          CustomHomeIconCard(
                            icon: Icons.gas_meter,
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
                              ? CustomHomeIconCard(
                                  icon: Icons.category,
                                  iconSize: 42,
                                  label: 'グループ一覧',
                                  labelFontSize: 16,
                                  color: kWhiteColor,
                                  backgroundColor: kGrey600Color,
                                  onTap: () => pushScreen(
                                    context,
                                    GroupScreen(
                                      loginProvider: loginProvider,
                                      homeProvider: homeProvider,
                                    ),
                                  ),
                                )
                              : Container(),
                          loginProvider.user?.admin == true
                              ? CustomHomeIconCard(
                                  icon: Icons.groups,
                                  iconSize: 42,
                                  label: 'スタッフ一覧',
                                  labelFontSize: 16,
                                  color: kWhiteColor,
                                  backgroundColor: kGrey600Color,
                                  onTap: () => pushScreen(
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
                      const SizedBox(height: 8),
                    ],
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
