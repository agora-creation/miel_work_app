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
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: kGrey600Color),
        ),
      ),
      child: ListTile(
        title: Text(
          notice.title,
          style: const TextStyle(fontSize: 20),
        ),
        subtitle: Text(
          dateText('yyyy/MM/dd HH:mm', notice.createdAt),
          style: const TextStyle(fontSize: 14),
        ),
        trailing: const FaIcon(
          FontAwesomeIcons.chevronRight,
          color: kGreyColor,
          size: 16,
        ),
        tileColor:
            !notice.readUserIds.contains(user?.id) ? kRed100Color : kWhiteColor,
        onTap: onTap,
      ),
    );
  }
}
