import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/apply.dart';

class ApplySelectScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ApplySelectScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ApplySelectScreen> createState() => _ApplySelectScreenState();
}

class _ApplySelectScreenState extends State<ApplySelectScreen> {
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
          '各種申請',
          style: TextStyle(color: kBlackColor),
        ),
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: ListView(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: kGrey600Color)),
            ),
            child: ListTile(
              title: const Text(
                '稟議申請',
                style: TextStyle(fontSize: 20),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => pushScreen(
                context,
                ApplyScreen(
                  loginProvider: widget.loginProvider,
                  homeProvider: widget.homeProvider,
                  type: '稟議',
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: kGrey600Color)),
            ),
            child: ListTile(
              title: const Text(
                '支払伺い申請',
                style: TextStyle(fontSize: 20),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => pushScreen(
                context,
                ApplyScreen(
                  loginProvider: widget.loginProvider,
                  homeProvider: widget.homeProvider,
                  type: '支払伺い',
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: kGrey600Color)),
            ),
            child: ListTile(
              title: const Text(
                '協議・報告申請',
                style: TextStyle(fontSize: 20),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => pushScreen(
                context,
                ApplyScreen(
                  loginProvider: widget.loginProvider,
                  homeProvider: widget.homeProvider,
                  type: '協議・報告',
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: kGrey600Color)),
            ),
            child: ListTile(
              title: const Text(
                '企画申請',
                style: TextStyle(fontSize: 20),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => pushScreen(
                context,
                ApplyScreen(
                  loginProvider: widget.loginProvider,
                  homeProvider: widget.homeProvider,
                  type: '企画',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
