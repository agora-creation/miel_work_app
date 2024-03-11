import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/apply_conference.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/providers/apply_conference.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/services/user.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:provider/provider.dart';

class ApplyConferenceDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyConferenceModel conference;

  const ApplyConferenceDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.conference,
    super.key,
  });

  @override
  State<ApplyConferenceDetailScreen> createState() =>
      _ApplyConferenceDetailScreenState();
}

class _ApplyConferenceDetailScreenState
    extends State<ApplyConferenceDetailScreen> {
  UserService userService = UserService();
  List<UserModel> approvalUsers = [];

  void _init() async {
    approvalUsers = await userService.selectList(
      userIds: widget.conference.approvalUserIds,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final conferenceProvider = Provider.of<ApplyConferenceProvider>(context);
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
          '協議申請詳細',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          widget.conference.createdUserId == widget.loginProvider.user?.id &&
                  !widget.conference.approval
              ? TextButton(
                  onPressed: () async {
                    String? error = await conferenceProvider.delete(
                      conference: widget.conference,
                    );
                    if (error != null) {
                      if (!mounted) return;
                      showMessage(context, error, false);
                      return;
                    }
                    if (!mounted) return;
                    showMessage(context, '協議申請を削除しました', true);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    '削除する',
                    style: TextStyle(color: kRedColor),
                  ),
                )
              : Container(),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '提出日: ${dateText('yyyy/MM/dd HH:mm', widget.conference.createdAt)}',
                      style: const TextStyle(color: kGreyColor),
                    ),
                    Text(
                      '作成者: ${widget.conference.createdUserName}',
                      style: const TextStyle(color: kGreyColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              FormLabel(
                label: '件名',
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    widget.conference.title,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                label: '承認者一覧',
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: kGrey600Color),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: approvalUsers.length,
                    itemBuilder: (context, index) {
                      UserModel user = approvalUsers[index];
                      return Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: kGrey600Color),
                          ),
                        ),
                        child: ListTile(
                          title: Text(user.name),
                          trailing: const Text('0000/00/00 00:00'),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                label: '内容',
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(widget.conference.content),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      floatingActionButton:
          widget.conference.createdUserId != widget.loginProvider.user?.id &&
                  !widget.conference.approval &&
                  !widget.conference.approvalUserIds
                      .contains(widget.loginProvider.user?.id)
              ? FloatingActionButton.extended(
                  onPressed: () async {
                    String? error = await conferenceProvider.update(
                      conference: widget.conference,
                      approval: widget.loginProvider.isAdmin(),
                      loginUser: widget.loginProvider.user,
                    );
                    if (error != null) {
                      if (!mounted) return;
                      showMessage(context, error, false);
                      return;
                    }
                    if (!mounted) return;
                    showMessage(context, '承認しました', true);
                    Navigator.pop(context);
                  },
                  backgroundColor: kRedColor,
                  icon: const Icon(
                    Icons.check,
                    color: kWhiteColor,
                  ),
                  label: const Text(
                    '承認する',
                    style: TextStyle(color: kWhiteColor),
                  ),
                )
              : Container(),
    );
  }
}
