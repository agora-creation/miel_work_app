import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/plan.dart';

class NowPlanList extends StatelessWidget {
  final PlanModel plan;
  final List<OrganizationGroupModel> groups;

  const NowPlanList({
    required this.plan,
    required this.groups,
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
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: plan.color.withOpacity(0.8),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 8,
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
                    fontSize: 14,
                  ),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  groupName,
                  style: const TextStyle(
                    color: kWhiteColor,
                    fontSize: 14,
                  ),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
            Text(
              '[${plan.category}]${plan.subject}',
              style: const TextStyle(
                color: kWhiteColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}