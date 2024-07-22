import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/report.dart';

class ReportList extends StatelessWidget {
  final DateTime day;
  final ReportModel? report;
  final Function()? onTap;

  const ReportList({
    required this.day,
    this.report,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: kGreyColor),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: dateText('E', day) == '土'
                    ? kLightBlueColor.withOpacity(0.3)
                    : dateText('E', day) == '日'
                        ? kDeepOrangeColor.withOpacity(0.3)
                        : Colors.transparent,
                radius: 24,
                child: Text(
                  dateText('dd(E)', day),
                  style: const TextStyle(
                    color: kBlackColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Expanded(
              child: report != null
                  ? ListTile(
                      tileColor: kGrey300Color,
                      title: const Text(
                        '記録済み',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SourceHanSansJP-Bold',
                        ),
                      ),
                      subtitle: report?.approval == 1
                          ? const Text(
                              '承認済み',
                              style: TextStyle(color: kRedColor),
                            )
                          : const Text(
                              '承認待ち',
                              style: TextStyle(color: kGreyColor),
                            ),
                      trailing: const FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: kGreyColor,
                        size: 18,
                      ),
                    )
                  : const ListTile(
                      trailing: FaIcon(
                        FontAwesomeIcons.pen,
                        color: kBlueColor,
                        size: 18,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
