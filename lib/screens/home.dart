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
import 'package:miel_work_app/widgets/home_grid_card.dart';
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
              HomeGridCard(
                label: '業務マニュアル',
                child: const Expanded(
                  child: Center(
                    child: Text(
                      'ありません',
                      style: TextStyle(color: kBlackColor),
                    ),
                  ),
                ),
                onTap: () => pushScreen(
                  context,
                  const ManualScreen(),
                ),
              ),
              HomeGridCard(
                label: 'お知らせ',
                child: const Expanded(
                  child: Center(
                    child: Text(
                      'ありません',
                      style: TextStyle(color: kBlackColor),
                    ),
                  ),
                ),
                onTap: () => pushScreen(
                  context,
                  const NoticeScreen(),
                ),
              ),
            ],
          ),
          HomeGridCard(
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
          HomeGridCard(
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
          HomeGridCard(
            label: '勤怠打刻',
            child: const Column(
              children: [
                ListTile(
                  title: Text('現在は出勤しておりません'),
                ),
              ],
            ),
            onTap: () => pushScreen(
              context,
              const CalendarScreen(),
            ),
          ),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: kHome3Grid,
            children: [
              HomeGridCard(
                label: 'メーター検針',
                child: const Expanded(
                  child: Center(
                    child: Text(
                      'ありません',
                      style: TextStyle(color: kBlackColor),
                    ),
                  ),
                ),
                onTap: () => pushScreen(
                  context,
                  const ManualScreen(),
                ),
              ),
              HomeGridCard(
                label: '稟議申請',
                child: const Expanded(
                  child: Center(
                    child: Text(
                      'ありません',
                      style: TextStyle(color: kBlackColor),
                    ),
                  ),
                ),
                onTap: () => pushScreen(
                  context,
                  const NoticeScreen(),
                ),
              ),
              HomeGridCard(
                label: 'スタッフ管理',
                child: const Expanded(
                  child: Center(
                    child: Text(
                      'ありません',
                      style: TextStyle(color: kBlackColor),
                    ),
                  ),
                ),
                onTap: () => pushScreen(
                  context,
                  const NoticeScreen(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
