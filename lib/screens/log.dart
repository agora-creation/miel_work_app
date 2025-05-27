import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/log.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/services/log.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/log_list.dart';

class LogScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const LogScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  LogService logService = LogService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.chevronLeft,
            color: kBlackColor,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '操作ログ',
          style: TextStyle(color: kBlackColor),
        ),
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: logService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                ),
                builder: (context, snapshot) {
                  List<LogModel> logs = [];
                  if (snapshot.hasData) {
                    logs = logService.generateList(
                      data: snapshot.data,
                    );
                  }
                  if (logs.isEmpty) {
                    return const Center(child: Text('操作ログはありません'));
                  }
                  return ListView.builder(
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      LogModel log = logs[index];
                      return LogList(log: log);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomFooter(
        loginProvider: widget.loginProvider,
        homeProvider: widget.homeProvider,
      ),
    );
  }
}
