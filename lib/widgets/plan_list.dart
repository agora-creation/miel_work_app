import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/plan.dart';

class PlanList extends StatelessWidget {
  final PlanModel plan;
  final List<OrganizationGroupModel> groups;
  final Function()? onTap;

  const PlanList({
    required this.plan,
    required this.groups,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String groupName = '';
    for (OrganizationGroupModel group in groups) {
      if (plan.groupId == group.id) {
        groupName = group.name;
      }
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: plan.categoryColor,
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
                    '${dateText('HH:mm', plan.startedAt)}〜${dateText('HH:mm', plan.endedAt)}',
                    style: const TextStyle(
                      color: kWhiteColor,
                      fontSize: 18,
                    ),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    groupName,
                    style: const TextStyle(
                      color: kWhiteColor,
                      fontSize: 18,
                    ),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
              Text(
                plan.category,
                style: const TextStyle(
                  color: kWhiteColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                plan.subject,
                style: const TextStyle(
                  color: kWhiteColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
