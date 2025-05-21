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
    bool commentNotRead = true;
    if (notice.comments.isNotEmpty) {
      for (final comment in notice.comments) {
        if (comment.readUserIds.contains(user?.id)) {
          commentNotRead = false;
        }
      }
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: !notice.readUserIds.contains(user?.id)
              ? kRedColor.withOpacity(0.3)
              : kWhiteColor,
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
                  Text(
                    notice.title,
                    style: const TextStyle(fontSize: 18),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    dateText('yyyy/MM/dd HH:mm', notice.createdAt),
                    style: const TextStyle(
                      color: kGreyColor,
                      fontSize: 14,
                    ),
                  ),
                  commentNotRead && notice.comments.isNotEmpty
                      ? const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Chip(
                            label: Text(
                              '未読コメントあり',
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
            ),
            notice.file != ''
                ? const Chip(
                    label: Icon(Icons.file_present),
                    backgroundColor: kCyanColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      side: BorderSide.none,
                    ),
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
