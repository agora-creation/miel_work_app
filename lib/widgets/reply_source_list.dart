import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/reply_source.dart';

class ReplySourceList extends StatelessWidget {
  final ReplySourceModel? replySource;
  final Function()? onTap;

  const ReplySourceList({
    required this.replySource,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kGrey200Color)),
      ),
      child: ListTile(
        title: Text(
          replySource?.createdUserName ?? '',
          style: const TextStyle(fontSize: 16),
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Text(
          replySource?.content ?? '',
          style: const TextStyle(fontSize: 14),
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        trailing: GestureDetector(
          onTap: onTap,
          child: const FaIcon(FontAwesomeIcons.xmark),
        ),
      ),
    );
  }
}
