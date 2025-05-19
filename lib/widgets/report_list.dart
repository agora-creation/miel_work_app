import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/report.dart';

class ReportList extends StatelessWidget {
  final ReportModel? report;
  final Function()? onTap;

  const ReportList({
    this.report,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return report != null
        ? ListTile(
            onTap: onTap,
            tileColor: report?.approval == 1
                ? kGreyColor.withOpacity(0.3)
                : kRedColor.withOpacity(0.3),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '記録済み',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                  ),
                ),
                report!.comments.isNotEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Chip(
                          label: Text(
                            'コメントあり',
                            style: TextStyle(
                              color: kLightGreenColor,
                              fontSize: 12,
                            ),
                          ),
                          backgroundColor: kWhiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          side: BorderSide(color: kLightGreenColor),
                        ),
                      )
                    : Container(),
              ],
            ),
            subtitle: report?.approval == 1
                ? const Text(
                    '承認済み',
                    style: TextStyle(color: kGreyColor),
                  )
                : const Text(
                    '承認待ち',
                    style: TextStyle(color: kRedColor),
                  ),
            trailing: const FaIcon(
              FontAwesomeIcons.chevronRight,
              color: kGreyColor,
              size: 18,
            ),
          )
        : Container();
  }
}
