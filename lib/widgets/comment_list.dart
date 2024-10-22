import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/comment.dart';

class CommentList extends StatelessWidget {
  final CommentModel comment;

  const CommentList({
    required this.comment,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      child: ListTile(
        title: Text(comment.content),
        subtitle: Text(
          '${dateText('yyyy/MM/dd HH:mm', comment.createdAt)} (${comment.userName})',
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
