import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/apply_conference.dart';
import 'package:miel_work_app/screens/apply_project.dart';
import 'package:miel_work_app/screens/apply_proposal.dart';
import 'package:miel_work_app/screens/chat.dart';
import 'package:miel_work_app/screens/group.dart';
import 'package:miel_work_app/screens/how_to.dart';
import 'package:miel_work_app/screens/manual.dart';
import 'package:miel_work_app/screens/notice.dart';
import 'package:miel_work_app/screens/plan.dart';
import 'package:miel_work_app/screens/plan_shift.dart';
import 'package:miel_work_app/screens/user.dart';
import 'package:miel_work_app/screens/user_setting.dart';
import 'package:miel_work_app/services/manual.dart';
import 'package:miel_work_app/services/notice.dart';
import 'package:miel_work_app/widgets/animation_background.dart';
import 'package:miel_work_app/widgets/custom_appbar.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/custom_home_chat_card.dart';
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
  ManualService manualService = ManualService();
  NoticeService noticeService = NoticeService();

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
                        const HowToScreen(),
                      ),
                      icon: const Icon(Icons.help_outline),
                    ),
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
                            stream: manualService.streamList(
                              organizationId: loginProvider.organization?.id,
                            ),
                            builder: (context, snapshot) {
                              bool alert = false;
                              if (snapshot.hasData) {
                                alert = manualService.checkAlert(
                                  data: snapshot.data,
                                  currentGroup: homeProvider.currentGroup,
                                  user: loginProvider.user,
                                );
                              }
                              return CustomHomeIconCard(
                                icon: Icons.picture_as_pdf,
                                label: '業務マニュアル',
                                color: kBlackColor,
                                backgroundColor: kWhiteColor,
                                alert: alert,
                                onTap: () => pushScreen(
                                  context,
                                  ManualScreen(
                                    loginProvider: loginProvider,
                                    homeProvider: homeProvider,
                                  ),
                                ),
                              );
                            },
                          ),
                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: noticeService.streamList(
                              organizationId: loginProvider.organization?.id,
                            ),
                            builder: (context, snapshot) {
                              bool alert = false;
                              if (snapshot.hasData) {
                                alert = manualService.checkAlert(
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
                        ],
                      ),
                      CustomHomeChatCard(
                        loginProvider: loginProvider,
                        homeProvider: homeProvider,
                        onTap: () => pushScreen(
                          context,
                          ChatScreen(
                            loginProvider: loginProvider,
                            homeProvider: homeProvider,
                          ),
                        ),
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
                        gridDelegate: kHome3Grid,
                        children: [
                          CustomHomeIconCard(
                            icon: Icons.view_timeline,
                            iconSize: 40,
                            label: 'シフト表',
                            labelFontSize: 14,
                            color: kBlackColor,
                            backgroundColor: kTeal300Color,
                            onTap: () => pushScreen(
                              context,
                              PlanShiftScreen(
                                loginProvider: loginProvider,
                                homeProvider: homeProvider,
                              ),
                            ),
                          ),
                          CustomHomeIconCard(
                            icon: Icons.edit_note,
                            iconSize: 40,
                            label: '稟議申請',
                            labelFontSize: 14,
                            color: kBlackColor,
                            backgroundColor: kOrange300Color,
                            onTap: () => pushScreen(
                              context,
                              ApplyProposalScreen(
                                loginProvider: loginProvider,
                                homeProvider: homeProvider,
                              ),
                            ),
                          ),
                          CustomHomeIconCard(
                            icon: Icons.edit_note,
                            iconSize: 40,
                            label: '協議・報告申請',
                            labelFontSize: 14,
                            color: kBlackColor,
                            backgroundColor: kOrange300Color,
                            onTap: () => pushScreen(
                              context,
                              ApplyConferenceScreen(
                                loginProvider: loginProvider,
                                homeProvider: homeProvider,
                              ),
                            ),
                          ),
                          CustomHomeIconCard(
                            icon: Icons.edit_note,
                            iconSize: 40,
                            label: '企画申請',
                            labelFontSize: 14,
                            color: kBlackColor,
                            backgroundColor: kOrange300Color,
                            onTap: () => pushScreen(
                              context,
                              ApplyProjectScreen(
                                loginProvider: loginProvider,
                                homeProvider: homeProvider,
                              ),
                            ),
                          ),
                          CustomHomeIconCard(
                            icon: Icons.gas_meter,
                            iconSize: 40,
                            label: 'メーター検針',
                            labelFontSize: 14,
                            color: kBlackColor,
                            backgroundColor: kYellowColor,
                            onTap: () async {
                              Uri url =
                                  Uri.parse('https://hirome.co.jp/meter/');
                              if (!await launchUrl(url)) {
                                throw Exception('Could not launch $url');
                              }
                            },
                          ),
                          loginProvider.isAdmin()
                              ? CustomHomeIconCard(
                                  icon: Icons.category,
                                  iconSize: 40,
                                  label: 'グループ管理',
                                  labelFontSize: 14,
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
                          loginProvider.isAdmin()
                              ? CustomHomeIconCard(
                                  icon: Icons.groups,
                                  iconSize: 40,
                                  label: 'スタッフ管理',
                                  labelFontSize: 14,
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
