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
              ? kRedColor.withOpacity(0.3)
              : kWhiteColor,
          border: Border(bottom: BorderSide(color: kBorderColor)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Chip(
                          label: Text(
                            problem.type,
                            style: const TextStyle(fontSize: 16),
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          backgroundColor: problem.typeColor(),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            problem.title,
                            style: const TextStyle(fontSize: 16),
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      problem.details,
                      style: const TextStyle(fontSize: 16),
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      dateText('yyyy/MM/dd HH:mm', problem.createdAt),
                      style: const TextStyle(fontSize: 14),
                    ),
                    problem.stateText() != ''
                        ? Text(
                            problem.stateText(),
                            style: const TextStyle(
                              color: kRedColor,
                              fontSize: 16,
                            ),
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )
                        : Container(),
                  ],
                ),
              ),
              const FaIcon(
                FontAwesomeIcons.chevronRight,
                color: kDisabledColor,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
