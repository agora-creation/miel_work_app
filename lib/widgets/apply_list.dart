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
        padding: const EdgeInsets.all(16),
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
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      side: BorderSide.none,
                    ),
                    side: BorderSide.none,
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
                    style: const TextStyle(
                      color: kGreyColor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '申請番号: ${apply.number}',
                    style: const TextStyle(
                      color: kGreyColor,
                      fontSize: 14,
                    ),
                  ),
                  apply.approval == 1
                      ? Text(
                          '承認日時: ${dateText('yyyy/MM/dd HH:mm', apply.approvedAt)}',
                          style: const TextStyle(
                            color: kRedColor,
                            fontSize: 14,
                          ),
                        )
                      : Container(),
                  apply.approval == 1
                      ? Text(
                          '承認番号: ${apply.approvalNumber}',
                          style: const TextStyle(
                            color: kRedColor,
                            fontSize: 14,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            apply.pending
                ? const Chip(
                    label: Text('保留中'),
                    backgroundColor: kYellowColor,
                    shape: StadiumBorder(side: BorderSide.none),
                    side: BorderSide.none,
                  )
                : const FaIcon(
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
