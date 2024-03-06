import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/plan.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/services/plan.dart';
import 'package:miel_work_app/widgets/now_plan_list.dart';

class CustomHomePlanCard extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final Function()? onTap;

  const CustomHomePlanCard({
    required this.loginProvider,
    required this.homeProvider,
    this.onTap,
    super.key,
  });

  @override
  State<CustomHomePlanCard> createState() => _CustomHomePlanCardState();
}

class _CustomHomePlanCardState extends State<CustomHomePlanCard> {
  PlanService planService = PlanService();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: kWhiteColor,
        surfaceTintColor: kWhiteColor,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: kGrey600Color)),
                ),
                child: const Text(
                  'スケジュール',
                  style: TextStyle(
                    color: kBlackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: planService.streamListNow(
                    organizationId: widget.loginProvider.organization?.id,
                  ),
                  builder: (context, snapshot) {
                    List<PlanModel> plans = [];
                    if (snapshot.hasData) {
                      plans = planService.generateList(
                        data: snapshot.data,
                        currentGroup: widget.homeProvider.currentGroup,
                      );
                    }
                    if (plans.isEmpty) {
                      return const Center(child: Text('今日の予定はありません'));
                    }
                    return Column(
                      children: plans.map((plan) {
                        return NowPlanList(
                          plan: plan,
                          groups: widget.homeProvider.groups,
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
