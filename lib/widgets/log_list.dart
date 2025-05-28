import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/log.dart';

class LogList extends StatelessWidget {
  final LogModel log;

  const LogList({
    required this.log,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                log.content,
                style: const TextStyle(fontSize: 16),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                '操作日時: ${dateText('yyyy/MM/dd HH:mm', log.createdAt)}',
                style: const TextStyle(
                  color: kGreyColor,
                  fontSize: 12,
                ),
              ),
              Text(
                '操作者: ${log.createdUserName}',
                style: const TextStyle(
                  color: kGreyColor,
                  fontSize: 12,
                ),
              ),
              Chip(
                label: Text(
                  log.device,
                  style: const TextStyle(
                    color: kBlackColor,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: kGreyColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                side: BorderSide.none,
              ),
            ],
          ),
          Container(),
        ],
      ),
    );
  }
}
