import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/approval_user.dart';

class CustomApprovalUserList extends StatelessWidget {
  final ApprovalUserModel approvalUser;

  const CustomApprovalUserList({
    required this.approvalUser,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      child: ListTile(
        tileColor: kRedColor.withOpacity(0.3),
        title: Text(
          approvalUser.userName,
          style: approvalUser.userPresident
              ? const TextStyle(
                  color: kRedColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                )
              : null,
        ),
        trailing: Text(
          dateText('yyyy/MM/dd HH:mm', approvalUser.approvedAt),
          style: const TextStyle(
            color: kRedColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'SourceHanSansJP-Bold',
          ),
        ),
      ),
    );
  }
}
