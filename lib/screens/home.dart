import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/chat.dart';
import 'package:miel_work_app/screens/group.dart';
import 'package:miel_work_app/screens/manual.dart';
import 'package:miel_work_app/screens/notice.dart';
import 'package:miel_work_app/screens/plan.dart';
import 'package:miel_work_app/screens/plan_shift.dart';
import 'package:miel_work_app/screens/user.dart';
import 'package:miel_work_app/screens/user_setting.dart';
import 'package:miel_work_app/services/manual.dart';
import 'package:miel_work_app/services/notice.dart';
import 'package:miel_work_app/widgets/custom_appbar_title.dart';
import 'package:miel_work_app/widgets/custom_icon_card.dart';
import 'package:miel_work_app/widgets/custom_list_card.dart';
import 'package:miel_work_app/widgets/group_select_card.dart';
import 'package:provider/provider.dart';

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
      appBar: AppBar(
        backgroundColor: kHomeBackgroundColor,
        automaticallyImplyLeading: false,
        title: CustomAppbarTitle(loginProvider: loginProvider),
        actions: [
          IconButton(
            onPressed: () => showBottomUpScreen(
              context,
              UserSettingScreen(
                loginProvider: loginProvider,
                homeProvider: homeProvider,
              ),
            ),
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ListView(
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
                  return CustomIconCard(
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
                  return CustomIconCard(
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
          CustomListCard(
            label: 'チャット',
            child: const Column(
              children: [
                ListTile(
                  title: Text('未読メッセージはありません'),
                ),
              ],
            ),
            onTap: () => pushScreen(
              context,
              ChatScreen(
                loginProvider: loginProvider,
                homeProvider: homeProvider,
              ),
            ),
          ),
          CustomListCard(
            label: 'スケジュール',
            child: const Column(
              children: [
                ListTile(
                  title: Text('今日の予定はありません'),
                ),
              ],
            ),
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
              CustomIconCard(
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
              // CustomIconCard(
              //   icon: Icons.gas_meter,
              //   iconSize: 40,
              //   label: 'メーター検針',
              //   labelFontSize: 14,
              //   color: kBlackColor,
              //   backgroundColor: kYellowColor,
              //   onTap: () {},
              // ),
              // CustomIconCard(
              //   icon: Icons.edit_note,
              //   iconSize: 40,
              //   label: '稟議申請',
              //   labelFontSize: 14,
              //   color: kBlackColor,
              //   backgroundColor: kOrangeColor,
              //   onTap: () {},
              // ),
              // CustomIconCard(
              //   icon: Icons.edit_note,
              //   iconSize: 40,
              //   label: '報告申請',
              //   labelFontSize: 14,
              //   color: kBlackColor,
              //   backgroundColor: kOrangeColor,
              //   onTap: () {},
              // ),
              loginProvider.isAdmin()
                  ? CustomIconCard(
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
                  ? CustomIconCard(
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
    );
  }
}
