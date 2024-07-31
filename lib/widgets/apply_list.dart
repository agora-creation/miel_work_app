import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/apply.dart';

class ApplyList extends StatelessWidget {
  final ApplyModel apply;
  final Function()? onTap;

  const ApplyList({
    required this.apply,
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
                  Chip(
                    label: Text('${apply.type}申請'),
                    backgroundColor: apply.typeColor(),
                  ),
                  Text(
                    apply.title,
                    style: const TextStyle(fontSize: 18),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    '申請日時: ${dateText('yyyy/MM/dd HH:mm', apply.createdAt)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    '申請番号: ${apply.number}',
                    style: const TextStyle(fontSize: 14),
                  ),
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
