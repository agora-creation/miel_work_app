import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/apply_proposal.dart';

class CustomApplyProposalList extends StatelessWidget {
  final ApplyProposalModel proposal;
  final Function()? onTap;

  const CustomApplyProposalList({
    required this.proposal,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      child: ListTile(
        title: Text(proposal.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('提出日: ${dateText('yyyy/MM/dd HH:mm', proposal.createdAt)}'),
            proposal.approval
                ? Text(
                    '承認日: ${dateText('yyyy/MM/dd HH:mm', proposal.createdAt)}')
                : Container(),
          ],
        ),
        trailing: proposal.approval
            ? const Chip(
                backgroundColor: kGrey600Color,
                label: Text(
                  '承認済み',
                  style: TextStyle(color: kWhiteColor),
                ),
              )
            : const Chip(
                backgroundColor: kRedColor,
                label: Text(
                  '承認待ち',
                  style: TextStyle(color: kWhiteColor),
                ),
              ),
        onTap: onTap,
      ),
    );
  }
}
