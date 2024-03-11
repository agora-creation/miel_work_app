import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/apply_proposal.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/apply_proposal_add.dart';
import 'package:miel_work_app/screens/apply_proposal_detail.dart';
import 'package:miel_work_app/services/apply_proposal.dart';
import 'package:miel_work_app/widgets/custom_apply_proposal_list.dart';

class ApplyProposalScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ApplyProposalScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ApplyProposalScreen> createState() => _ApplyProposalScreenState();
}

class _ApplyProposalScreenState extends State<ApplyProposalScreen> {
  ApplyProposalService proposalService = ApplyProposalService();
  bool searchApproval = false;

  void _searchApprovalChange(bool value) {
    setState(() {
      searchApproval = value;
    });
  }

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
          '稟議申請一覧',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => ApprovalSelectDialog(
                searchApproval: searchApproval,
                searchApprovalChange: _searchApprovalChange,
              ),
            ),
            icon: const Icon(Icons.search),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: proposalService.streamList(
          organizationId: widget.loginProvider.organization?.id,
          approval: searchApproval,
        ),
        builder: (context, snapshot) {
          List<ApplyProposalModel> proposals = [];
          if (snapshot.hasData) {
            proposals = proposalService.generateList(
              data: snapshot.data,
              currentGroup: widget.homeProvider.currentGroup,
            );
          }
          if (proposals.isEmpty) {
            return const Center(child: Text('稟議申請はありません'));
          }
          return ListView.builder(
            itemCount: proposals.length,
            itemBuilder: (context, index) {
              ApplyProposalModel proposal = proposals[index];
              return CustomApplyProposalList(
                proposal: proposal,
                onTap: () => pushScreen(
                  context,
                  ApplyProposalDetailScreen(
                    loginProvider: widget.loginProvider,
                    homeProvider: widget.homeProvider,
                    proposal: proposal,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => pushScreen(
          context,
          ApplyProposalAddScreen(
            loginProvider: widget.loginProvider,
            homeProvider: widget.homeProvider,
          ),
        ),
        child: const Icon(Icons.add, color: kWhiteColor),
      ),
    );
  }
}

class ApprovalSelectDialog extends StatefulWidget {
  final bool searchApproval;
  final Function(bool) searchApprovalChange;

  const ApprovalSelectDialog({
    required this.searchApproval,
    required this.searchApprovalChange,
    super.key,
  });

  @override
  State<ApprovalSelectDialog> createState() => _ApprovalSelectDialogState();
}

class _ApprovalSelectDialogState extends State<ApprovalSelectDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      content: Container(
        decoration: BoxDecoration(border: Border.all(color: kGrey600Color)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: kGrey600Color)),
                ),
                child: RadioListTile<bool>(
                  title: const Text('承認待ち'),
                  value: false,
                  groupValue: widget.searchApproval,
                  onChanged: (value) {
                    widget.searchApprovalChange(value ?? false);
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: kGrey600Color)),
                ),
                child: RadioListTile<bool>(
                  title: const Text('承認済み'),
                  value: true,
                  groupValue: widget.searchApproval,
                  onChanged: (value) {
                    widget.searchApprovalChange(value ?? false);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
