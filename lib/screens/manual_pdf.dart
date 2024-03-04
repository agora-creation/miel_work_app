import 'dart:io';

import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/manual.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/manual_mod.dart';
import 'package:miel_work_app/services/manual.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ManualPdfScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ManualModel manual;

  const ManualPdfScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.manual,
    super.key,
  });

  @override
  State<ManualPdfScreen> createState() => _ManualPdfScreenState();
}

class _ManualPdfScreenState extends State<ManualPdfScreen> {
  ManualService manualService = ManualService();

  void _init() async {
    UserModel? user = widget.loginProvider.user;
    List<String> readUserIds = widget.manual.readUserIds;
    if (!readUserIds.contains(user?.id)) {
      readUserIds.add(user?.id ?? '');
      manualService.update({
        'id': widget.manual.id,
        'readUserIds': readUserIds,
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    File file = File(widget.manual.file);
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
        title: Text(
          widget.manual.title,
          style: const TextStyle(color: kBlackColor),
        ),
        actions: [
          widget.loginProvider.isAdmin()
              ? IconButton(
                  onPressed: () => showBottomUpScreen(
                    context,
                    ManualModScreen(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      manual: widget.manual,
                    ),
                  ),
                  icon: const Icon(Icons.edit, color: kBlueColor),
                )
              : Container(),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: SfPdfViewer.network(file.path),
    );
  }
}
