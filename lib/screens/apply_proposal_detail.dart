import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/apply_proposal.dart';
import 'package:miel_work_app/providers/apply_proposal.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
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
        actions: [
          TextButton(
            onPressed: () async {
              String? error = await proposalProvider.update(
                proposal: widget.proposal,
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
            child: const Text('承認'),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(widget.proposal.content),
          Text(widget.proposal.price.toString()),
          const SizedBox(height: 8),
          const Divider(height: 1, color: kGrey300Color),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              dateText('yyyy/MM/dd HH:mm', widget.proposal.createdAt),
              style: const TextStyle(color: kGreyColor),
            ),
          ),
        ],
      ),
    );
  }
}
