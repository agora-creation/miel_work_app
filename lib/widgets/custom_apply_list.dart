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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: kGrey600Color)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '[${apply.type}申請]',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        apply.title,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: kGrey600Color,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '申請日時: ${dateText('yyyy/MM/dd HH:mm', apply.createdAt)}',
                    style: const TextStyle(
                      color: kGrey600Color,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  apply.approval == 1
                      ? Text(
                          '承認日時: ${dateText('yyyy/MM/dd HH:mm', apply.approvedAt)}',
                          style: const TextStyle(
                            color: kRedColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
