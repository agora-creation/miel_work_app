import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/apply_proposal.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/providers/apply_proposal.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/services/user.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/link_text.dart';
import 'package:provider/provider.dart';

class ApplyProposalDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyProposalModel proposal;

  const ApplyProposalDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.proposal,
    super.key,
  });

  @override
  State<ApplyProposalDetailScreen> createState() =>
      _ApplyProposalDetailScreenState();
}

class _ApplyProposalDetailScreenState extends State<ApplyProposalDetailScreen> {
  UserService userService = UserService();
  List<UserModel> approvalUsers = [];

  void _init() async {
    approvalUsers = await userService.selectList(
      userIds: widget.proposal.approvalUserIds,
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
    final proposalProvider = Provider.of<ApplyProposalProvider>(context);
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
          widget.proposal.title,
          style: const TextStyle(color: kBlackColor),
        ),
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
                      '作成日：${dateText('yyyy/MM/dd HH:mm', widget.proposal.createdAt)}',
                      style: const TextStyle(color: kGreyColor),
                    ),
                    Text(
                      '作成者：${widget.proposal.createdUserName}',
                      style: const TextStyle(color: kGreyColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                label: '内容',
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(widget.proposal.content),
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                label: '金額',
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    '¥${widget.proposal.price}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                label: '承認者一覧',
                child: Container(
                  height: 200,
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
                        child: ListTile(title: Text(user.name)),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              widget.proposal.createdUserId == widget.loginProvider.user?.id &&
                      !widget.proposal.approval
                  ? LinkText(
                      label: 'この稟議申請を削除',
                      color: kRedColor,
                      onTap: () async {
                        String? error = await proposalProvider.delete(
                          proposal: widget.proposal,
                        );
                        if (error != null) {
                          if (!mounted) return;
                          showMessage(context, error, false);
                          return;
                        }
                        if (!mounted) return;
                        showMessage(context, '稟議申請を削除しました', true);
                        Navigator.pop(context);
                      },
                    )
                  : Container(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      floatingActionButton:
          widget.proposal.createdUserId != widget.loginProvider.user?.id
              ? FloatingActionButton.extended(
                  onPressed: () async {
                    String? error = await proposalProvider.update(
                      proposal: widget.proposal,
                      approval: widget.loginProvider.isAdmin(),
                      user: widget.loginProvider.user,
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
