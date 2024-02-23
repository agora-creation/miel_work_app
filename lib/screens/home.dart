import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/calendar.dart';
import 'package:miel_work_app/screens/chat.dart';
import 'package:miel_work_app/screens/group.dart';
import 'package:miel_work_app/screens/manual.dart';
import 'package:miel_work_app/screens/notice.dart';
import 'package:miel_work_app/screens/user.dart';
import 'package:miel_work_app/screens/users.dart';
import 'package:miel_work_app/screens/work.dart';
import 'package:miel_work_app/widgets/group_list_tile.dart';
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
    final userProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(userProvider.user?.name ?? ''),
        actions: [
          IconButton(
            onPressed: () => showBottomUpScreen(
              context,
              UserScreen(userProvider: userProvider),
            ),
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          GroupListTile(
            onTap: () => pushScreen(
              context,
              GroupScreen(userProvider: userProvider),
            ),
          ),
          const SizedBox(height: 8),
          GridView(
            shrinkWrap: true,
            gridDelegate: kHomeGrid,
            children: [
              HomeGridCard(
                label: '業務マニュアル',
                child: Container(),
                onTap: () => pushScreen(
                  context,
                  const ManualScreen(),
                ),
              ),
              HomeGridCard(
                label: 'お知らせ',
                child: Container(),
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
                  title: Text('メッセージはありません'),
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
          GridView(
            shrinkWrap: true,
            gridDelegate: kHomeGrid,
            children: [
              HomeGridCard(
                label: 'スタッフ管理',
                child: Container(),
                onTap: () => pushScreen(
                  context,
                  const UsersScreen(),
                ),
              ),
              HomeGridCard(
                label: '勤怠打刻',
                child: Container(),
                onTap: () => pushScreen(
                  context,
                  const WorkScreen(),
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
