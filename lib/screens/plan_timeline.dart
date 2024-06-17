import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/plan.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/plan_add.dart';
import 'package:miel_work_app/screens/plan_mod.dart';
import 'package:miel_work_app/services/config.dart';
import 'package:miel_work_app/services/plan.dart';
import 'package:miel_work_app/widgets/plan_list.dart';

class PlanTimelineScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final DateTime date;

  const PlanTimelineScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.date,
    super.key,
  });

  @override
  State<PlanTimelineScreen> createState() => _PlanTimelineScreenState();
}

class _PlanTimelineScreenState extends State<PlanTimelineScreen> {
  PlanService planService = PlanService();
  List<String> searchCategories = [];

  void _init() async {
    await ConfigService().checkReview();
  }

  void _searchCategoriesChange() async {
    searchCategories = await getPrefsList('categories') ?? [];
    setState(() {});
  }

  @override
  void initState() {
    _searchCategoriesChange();
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        automaticallyImplyLeading: false,
        title: Text(
          dateText('yyyy年MM月dd日(E)', widget.date),
          style: const TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: kBlackColor,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: planService.streamList(
            organizationId: widget.loginProvider.organization?.id,
            categories: searchCategories,
          ),
          builder: (context, snapshot) {
            List<PlanModel> plans = [];
            if (snapshot.hasData) {
              plans = planService.generateList(
                data: snapshot.data,
                currentGroup: widget.homeProvider.currentGroup,
                date: widget.date,
              );
            }
            if (plans.isEmpty) {
              return const Center(child: Text('予定はありません'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: plans.length,
              itemBuilder: (context, index) {
                PlanModel plan = plans[index];
                return PlanList(
                  plan: plan,
                  groups: widget.homeProvider.groups,
                  onTap: () => pushScreen(
                    context,
                    PlanModScreen(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      planId: plan.id,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => pushScreen(
          context,
          PlanAddScreen(
            loginProvider: widget.loginProvider,
            homeProvider: widget.homeProvider,
            date: widget.date,
          ),
        ),
        icon: const Icon(
          Icons.add,
          color: kWhiteColor,
        ),
        label: const Text(
          '新規追加',
          style: TextStyle(
            color: kWhiteColor,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
