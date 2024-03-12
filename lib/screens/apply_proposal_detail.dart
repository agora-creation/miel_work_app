import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/apply_proposal.dart';
import 'package:miel_work_app/models/approval_user.dart';
import 'package:miel_work_app/providers/apply_proposal.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/widgets/custom_approval_user_list.dart';
import 'package:miel_work_app/widgets/form_label.dart';
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
  @override
  Widget build(BuildContext context) {
    final proposalProvider = Provider.of<ApplyProposalProvider>(context);
    bool isApproval = true;
    bool isDelete = true;
    if (widget.proposal.createdUserId == widget.loginProvider.user?.id) {
      isApproval = false;
    } else {
      isDelete = false;
    }
    if (widget.proposal.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel user in widget.proposal.approvalUsers) {
        if (user.userId == widget.loginProvider.user?.id) {
          isApproval = false;
        }
      }
    }
    if (widget.proposal.approval) {
      isApproval = false;
      isDelete = false;
    }
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
          '稟議申請詳細',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          isDelete
              ? TextButton(
                  onPressed: () async {
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
                      '提出日: ${dateText('yyyy/MM/dd HH:mm', widget.proposal.createdAt)}',
                      style: const TextStyle(color: kGreyColor),
                    ),
                    Text(
                      '作成者: ${widget.proposal.createdUserName}',
                      style: const TextStyle(color: kGreyColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              FormLabel(
                label: '承認者一覧',
                child: Container(
                  height: 150,
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: kGrey600Color)),
                  ),
                  child: widget.proposal.approvalUsers.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.proposal.approvalUsers.length,
                          itemBuilder: (context, index) {
                            ApprovalUserModel approvalUser =
                                widget.proposal.approvalUsers[index];
                            return CustomApprovalUserList(
                                approvalUser: approvalUser);
                          },
                        )
                      : const Center(child: Text('承認者はいません')),
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                label: '件名',
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    widget.proposal.title,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                label: '金額',
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    '¥ ${widget.proposal.formatPrice()}',
                    style: const TextStyle(fontSize: 18),
                  ),
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
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      floatingActionButton: isApproval
          ? FloatingActionButton.extended(
              onPressed: () async {
                String? error = await proposalProvider.update(
                  proposal: widget.proposal,
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
