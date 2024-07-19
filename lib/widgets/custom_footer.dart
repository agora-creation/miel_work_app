import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/plan_now.dart';
import 'package:miel_work_app/services/config.dart';
import 'package:miel_work_app/widgets/custom_button_sm.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomFooter extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const CustomFooter({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<CustomFooter> createState() => _CustomFooterState();
}

class _CustomFooterState extends State<CustomFooter>
    with WidgetsBindingObserver {
  void _versionCheck() async {
    if (await ConfigService().checkVersion()) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => const VersionUpDialog(),
      );
    }
  }

  void _nowCheck() async {
    DateTime now = DateTime.now();
    String? prefsNow = await getPrefsString('now');
    if (prefsNow == null) {
      await _show();
    } else {
      if (dateText('yyyyMMdd', now) != prefsNow) {
        await _show();
      }
    }
  }

  Future _show() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    showBottomUpScreen(
      context,
      PlanNowScreen(
        loginProvider: widget.loginProvider,
        homeProvider: widget.homeProvider,
      ),
    ).then((value) async {
      DateTime now = DateTime.now();
      String prefsNow = dateText('yyyyMMdd', now);
      await setPrefsString('now', prefsNow);
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    FlutterAppBadger.removeBadge();
    _nowCheck();
    _versionCheck();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FlutterAppBadger.removeBadge();
    } else if (state == AppLifecycleState.paused) {
    } else if (state == AppLifecycleState.detached) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(height: 0);
  }
}

class VersionUpDialog extends StatelessWidget {
  const VersionUpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      title: const Text(
        'バージョンアップのお知らせ',
        style: TextStyle(fontSize: 16),
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('新しいバージョンのアプリが利用可能になりました。アプリストアより更新を行ってから、ご利用ください。'),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        CustomButtonSm(
          label: '閉じる',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButtonSm(
          label: '更新する',
          labelColor: kWhiteColor,
          backgroundColor: kDeepOrangeColor,
          onPressed: () async {
            String urlText = '';
            if (Platform.isIOS) {
              urlText = ConfigService().APP_STORE_URL;
            } else {
              urlText = ConfigService().PLAY_STORE_URL;
            }
            Uri url = Uri.parse(urlText);
            if (!await launchUrl(url)) {
              throw Exception('Could not launch $url');
            }
          },
        ),
      ],
    );
  }
}
