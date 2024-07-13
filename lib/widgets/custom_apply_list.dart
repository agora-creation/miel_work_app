import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/apply.dart';

class CustomApplyList extends StatelessWidget {
  final ApplyModel apply;
  final Function()? onTap;

  const CustomApplyList({
    required this.apply,
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
        title: Text(
          apply.title,
          style: const TextStyle(fontSize: 20),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '申請日時: ${dateText('yyyy/MM/dd HH:mm', apply.createdAt)}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              '申請番号: ${apply.number}',
              style: const TextStyle(fontSize: 14),
            ),
            apply.approval == 1
                ? Text(
                    '承認日時: ${dateText('yyyy/MM/dd HH:mm', apply.approvedAt)}',
                    style: const TextStyle(
                      color: kRedColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Container(),
            apply.approval == 1
                ? Text(
                    '承認番号: ${apply.approvalNumber}',
                    style: const TextStyle(
                      color: kRedColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Container(),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
