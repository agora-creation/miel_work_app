import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/request_cycle.dart';

class RequestCycleList extends StatelessWidget {
  final RequestCycleModel cycle;
  final Function()? onTap;

  const RequestCycleList({
    required this.cycle,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: kBorderColor)),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cycle.companyName,
                    style: const TextStyle(fontSize: 18),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    '使用者名: ${cycle.companyUserName}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    '申込日時: ${dateText('yyyy/MM/dd HH:mm', cycle.createdAt)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  cycle.approval == 1
                      ? Text(
                          '承認日時: ${dateText('yyyy/MM/dd HH:mm', cycle.approvedAt)}',
                          style: const TextStyle(
                            color: kRedColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            const FaIcon(
              FontAwesomeIcons.chevronRight,
              color: kDisabledColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
