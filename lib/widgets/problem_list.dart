import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/problem.dart';
import 'package:miel_work_app/models/user.dart';

class ProblemList extends StatelessWidget {
  final ProblemModel problem;
  final UserModel? user;
  final Function()? onTap;

  const ProblemList({
    required this.problem,
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
          color: !problem.readUserIds.contains(user?.id)
              ? kRed100Color
              : kWhiteColor,
          border: const Border(
            bottom: BorderSide(color: kGrey600Color),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(
                    label: Text(
                      problem.type,
                      style: const TextStyle(fontSize: 18),
                    ),
                    backgroundColor: problem.typeColor(),
                  ),
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
              const FaIcon(
                FontAwesomeIcons.chevronRight,
                color: kGrey600Color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
