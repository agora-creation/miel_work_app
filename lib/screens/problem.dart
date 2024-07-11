import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/problem.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/problem_add.dart';
import 'package:miel_work_app/screens/problem_detail.dart';
import 'package:miel_work_app/services/config.dart';
import 'package:miel_work_app/services/problem.dart';
import 'package:miel_work_app/widgets/custom_problem_list.dart';

class ProblemScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ProblemScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ProblemScreen> createState() => _ProblemScreenState();
}

class _ProblemScreenState extends State<ProblemScreen> {
  ProblemService problemService = ProblemService();
  DateTime? searchStart;
  DateTime? searchEnd;

  void _init() async {
    await ConfigService().checkReview();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: kBlackColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'クレーム／要望',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              var selected = await showDataRangePickerDialog(
                context: context,
                startValue: searchStart,
                endValue: searchEnd,
              );
              if (selected != null &&
                  selected.first != null &&
                  selected.last != null) {
                var diff = selected.last!.difference(selected.first!);
                int diffDays = diff.inDays;
                if (diffDays > 31) {
                  if (!mounted) return;
                  showMessage(context, '1ヵ月以上の範囲が選択されています', false);
                  return;
                }
                searchStart = selected.first;
                searchEnd = selected.last;
                setState(() {});
              }
            },
            icon: const Icon(Icons.date_range, color: kBlueColor),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: problemService.streamList(
          organizationId: widget.loginProvider.organization?.id,
          searchStart: searchStart,
          searchEnd: searchEnd,
        ),
        builder: (context, snapshot) {
          List<ProblemModel> problems = [];
          if (snapshot.hasData) {
            problems = problemService.generateList(
              data: snapshot.data,
            );
          }
          if (problems.isEmpty) {
            return const Center(child: Text('クレーム／要望はありません'));
          }
          return ListView.builder(
            itemCount: problems.length,
            itemBuilder: (context, index) {
              ProblemModel problem = problems[index];
              return CustomProblemList(
                problem: problem,
                user: widget.loginProvider.user,
                onTap: () => pushScreen(
                  context,
                  ProblemDetailScreen(
                    loginProvider: widget.loginProvider,
                    homeProvider: widget.homeProvider,
                    problem: problem,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => pushScreen(
          context,
          ProblemAddScreen(
            loginProvider: widget.loginProvider,
            homeProvider: widget.homeProvider,
          ),
        ),
        icon: const Icon(
          Icons.add,
          color: kWhiteColor,
        ),
        label: const Text(
          '新規追加',
          style: TextStyle(color: kWhiteColor),
        ),
      ),
    );
  }
}
