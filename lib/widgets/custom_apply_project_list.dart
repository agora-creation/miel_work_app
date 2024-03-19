import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/apply_project.dart';

class CustomApplyProjectList extends StatelessWidget {
  final ApplyProjectModel project;
  final Function()? onTap;

  const CustomApplyProjectList({
    required this.project,
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
        title: Text(project.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('提出日時: ${dateText('yyyy/MM/dd HH:mm', project.createdAt)}'),
            project.approval == 1
                ? Text(
                    '承認日時: ${dateText('yyyy/MM/dd HH:mm', project.approvedAt)}',
                    style: const TextStyle(
                      color: kRedColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Container(),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
