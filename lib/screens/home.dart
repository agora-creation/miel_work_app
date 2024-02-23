import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/calendar.dart';
import 'package:miel_work_app/screens/chat.dart';
import 'package:miel_work_app/screens/manual.dart';
import 'package:miel_work_app/screens/notice.dart';
import 'package:miel_work_app/screens/user_setting.dart';
import 'package:miel_work_app/widgets/custom_appbar_title.dart';
import 'package:miel_work_app/widgets/custom_icon_card.dart';
import 'package:miel_work_app/widgets/custom_list_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CustomAppbarTitle(loginProvider: loginProvider),
        actions: [
          IconButton(
            onPressed: () => showBottomUpScreen(
              context,
              UserSettingScreen(loginProvider: loginProvider),
            ),
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: kHome2Grid,
            children: [
              CustomIconCard(
                icon: Icons.picture_as_pdf,
                label: '業務マニュアル',
                color: kWhiteColor,
                backgroundColor: kRedColor,
                onTap: () => pushScreen(
                  context,
                  const ManualScreen(),
                ),
              ),
              CustomIconCard(
                icon: Icons.notifications,
                label: 'お知らせ',
                color: kBlackColor,
                backgroundColor: kWhiteColor,
                onTap: () => pushScreen(
                  context,
                  const NoticeScreen(),
                ),
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
              const ChatScreen(),
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
              const CalendarScreen(),
            ),
          ),
          CustomListCard(
            label: '勤怠打刻',
            child: const Column(
              children: [
                ListTile(
                  title: Text('現在は出勤しておりません'),
                ),
              ],
            ),
            onTap: () {},
          ),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: kHome3Grid,
            children: [
              CustomIconCard(
                icon: Icons.gas_meter,
                iconSize: 40,
                label: 'メーター検針',
                labelFontSize: 14,
                color: kBlackColor,
                backgroundColor: kYellowColor,
                onTap: () {},
              ),
              CustomIconCard(
                icon: Icons.edit_note,
                iconSize: 40,
                label: '稟議申請',
                labelFontSize: 14,
                color: kBlackColor,
                backgroundColor: kOrangeColor,
                onTap: () {},
              ),
              CustomIconCard(
                icon: Icons.group,
                iconSize: 40,
                label: 'スタッフ管理',
                labelFontSize: 14,
                color: kBlackColor,
                backgroundColor: kGreyColor,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
