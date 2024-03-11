import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/apply_conference.dart';

class CustomApplyConferenceList extends StatelessWidget {
  final ApplyConferenceModel conference;
  final Function()? onTap;

  const CustomApplyConferenceList({
    required this.conference,
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
        title: Text(conference.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('提出日: ${dateText('yyyy/MM/dd HH:mm', conference.createdAt)}'),
            conference.approval
                ? Text(
                    '承認日: ${dateText('yyyy/MM/dd HH:mm', conference.createdAt)}')
                : Container(),
          ],
        ),
        trailing: conference.approval
            ? const Chip(
                backgroundColor: kGrey600Color,
                label: Text(
                  '承認済み',
                  style: TextStyle(color: kWhiteColor),
                ),
              )
            : const Chip(
                backgroundColor: kRedColor,
                label: Text(
                  '承認待ち',
                  style: TextStyle(color: kWhiteColor),
                ),
              ),
        onTap: onTap,
      ),
    );
  }
}
