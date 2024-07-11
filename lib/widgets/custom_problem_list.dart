import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/problem.dart';
import 'package:miel_work_app/models/user.dart';

class CustomProblemList extends StatelessWidget {
  final ProblemModel problem;
  final UserModel? user;
  final Function()? onTap;

  const CustomProblemList({
    required this.problem,
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
          problem.type,
          style: const TextStyle(fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '報告日時: ${dateText('yyyy/MM/dd HH:mm', problem.createdAt)}',
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              '対応者: ${problem.picName}',
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            problem.targetName != ''
                ? Text(
                    '相手の名前: ${problem.targetName}',
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )
                : Container(),
            problem.stateText() != ''
                ? Text(
                    problem.stateText(),
                    style: const TextStyle(color: kRedColor),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )
                : Container(),
          ],
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: kGreyColor,
        ),
        tileColor: !problem.readUserIds.contains(user?.id)
            ? kRed100Color
            : kWhiteColor,
        onTap: onTap,
      ),
    );
  }
}
