import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/plan.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/services/plan.dart';
import 'package:miel_work_app/widgets/now_plan_list.dart';

class PlanNowScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const PlanNowScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<PlanNowScreen> createState() => _PlanNowScreenState();
}

class _PlanNowScreenState extends State<PlanNowScreen> {
  PlanService planService = PlanService();

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        automaticallyImplyLeading: false,
        title: Text(
          '${dateText('MM月dd日(E)', now)}の予定',
          style: const TextStyle(
            color: kBlackColor,
            fontSize: 24,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: planService.streamList(
          organizationId: widget.loginProvider.organization?.id,
          categories: [],
        ),
        builder: (context, snapshot) {
          List<PlanModel> plans = [];
          if (snapshot.hasData) {
            plans = planService.generateList(
              data: snapshot.data,
              currentGroup: widget.homeProvider.currentGroup,
              date: now,
            );
          }
          if (plans.isEmpty) {
            return const Center(child: Text('今日の予定はありません'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: plans.length,
            itemBuilder: (context, index) {
              PlanModel plan = plans[index];
              return NowPlanList(
                plan: plan,
                groups: widget.homeProvider.groups,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        icon: const FaIcon(
          FontAwesomeIcons.downLong,
          color: kWhiteColor,
        ),
        label: const Text(
          'ホームへ',
          style: TextStyle(
            color: kWhiteColor,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
