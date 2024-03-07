import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/plan_now.dart';

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
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    _nowCheck();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
    } else if (state == AppLifecycleState.paused) {
    } else if (state == AppLifecycleState.detached) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(height: 0);
  }
}
