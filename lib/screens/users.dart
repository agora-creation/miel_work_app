import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';

class UsersScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const UsersScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: kBlackColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'スタッフ管理',
          style: TextStyle(color: kBlackColor),
        ),
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
    );
  }
}
