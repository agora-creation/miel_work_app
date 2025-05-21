import 'package:flutter/material.dart';
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
    bool commentNotRead = true;
    if (problem.comments.isNotEmpty) {
      for (final comment in problem.comments) {
        if (comment.readUserIds.contains(user?.id)) {
          commentNotRead = false;
        }
      }
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: problem.typeColor(),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateText('yyyy/MM/dd HH:mm', problem.createdAt),
                    style: const TextStyle(
                      color: kBlackColor,
                      fontSize: 16,
                    ),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    problem.type,
                    style: const TextStyle(
                      color: kBlackColor,
                      fontSize: 16,
                    ),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
              Text(
                problem.title,
                style: const TextStyle(
                  color: kBlackColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              problem.stateText() != ''
                  ? Text(
                      problem.stateText(),
                      style: const TextStyle(
                        color: kRedColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SourceHanSansJP-Bold',
                      ),
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    )
                  : Container(),
              commentNotRead && problem.comments.isNotEmpty
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
      ),
    );
  }
}
