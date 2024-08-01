import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/plan.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/services/plan.dart';
import 'package:miel_work_app/widgets/plan_list.dart';

class HomePlanCard extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final Function()? onTap;

  const HomePlanCard({
    required this.loginProvider,
    required this.homeProvider,
    this.onTap,
    super.key,
  });

  @override
  State<HomePlanCard> createState() => _HomePlanCardState();
}

class _HomePlanCardState extends State<HomePlanCard> {
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
            vertical: 10,
            horizontal: 14,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: kBorderColor)),
                ),
                child: const Text(
                  'スケジュール',
                  style: TextStyle(
                    color: kBlackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: planService.streamList(
                    organizationId: widget.loginProvider.organization?.id,
                    searchCategories: [],
                  ),
                  builder: (context, snapshot) {
                    List<PlanModel> plans = [];
                    DateTime now = DateTime.now();
                    if (snapshot.hasData) {
                      plans = planService.generateList(
                        data: snapshot.data,
                        currentGroup: widget.homeProvider.currentGroup,
                        searchStart: DateTime(
                          now.year,
                          now.month,
                          now.day,
                          0,
                          0,
                          0,
                        ),
                        searchEnd: DateTime(
                          now.year,
                          now.month,
                          now.day,
                          23,
                          59,
                          59,
                        ),
                      );
                    }
                    if (plans.isEmpty) {
                      return const Center(child: Text('今日の予定はありません'));
                    }
                    return Column(
                      children: plans.map((plan) {
                        return PlanList(
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
