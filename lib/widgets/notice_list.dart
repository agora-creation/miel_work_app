import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/notice.dart';
import 'package:miel_work_app/models/user.dart';

class NoticeList extends StatelessWidget {
  final NoticeModel notice;
  final UserModel? user;
  final Function()? onTap;

  const NoticeList({
    required this.notice,
    required this.user,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: !notice.readUserIds.contains(user?.id)
              ? kRed100Color
              : kWhiteColor,
          border: const Border(
            bottom: BorderSide(color: kGrey600Color),
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notice.title,
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  dateText('yyyy/MM/dd HH:mm', notice.createdAt),
                  style: const TextStyle(fontSize: 14),
                ),
                notice.file != ''
                    ? const Chip(
                        label: Text('添付あり'),
                        backgroundColor: kBlue100Color,
                      )
                    : Container(),
              ],
            ),
            const FaIcon(
              FontAwesomeIcons.chevronRight,
              color: kGreyColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
