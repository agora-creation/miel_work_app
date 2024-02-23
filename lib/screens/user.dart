import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/login.dart';
import 'package:miel_work_app/widgets/link_text.dart';
import 'package:miel_work_app/widgets/user_info_list.dart';

class UserScreen extends StatefulWidget {
  final LoginProvider userProvider;

  const UserScreen({
    required this.userProvider,
    super.key,
  });

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        automaticallyImplyLeading: false,
        title: Text(
          '${widget.userProvider.user?.name}の設定',
          style: const TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: kBlackColor,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
        shape: const Border(
          bottom: BorderSide(color: kGrey600Color),
        ),
      ),
      body: Column(
        children: [
          UserInfoList(
            headingLabel: '名前',
            values: [widget.userProvider.user?.name ?? ''],
          ),
          UserInfoList(
            headingLabel: 'メールアドレス',
            values: [widget.userProvider.user?.email ?? ''],
          ),
          UserInfoList(
            headingLabel: 'パスワード',
            values: [widget.userProvider.user?.password ?? ''],
          ),
          const UserInfoList(
            headingLabel: '所属中の団体',
            values: ['ひろめ市場 インフォメーション', 'ひろめ市場 食器センター'],
          ),
          const SizedBox(height: 16),
          LinkText(
            label: 'この端末からログアウトする',
            color: kRedColor,
            onTap: () async {
              await widget.userProvider.signOut();
              if (!mounted) return;
              pushReplacementScreen(context, const LoginScreen());
            },
          ),
        ],
      ),
    );
  }
}
