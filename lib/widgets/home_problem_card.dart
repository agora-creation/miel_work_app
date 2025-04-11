import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/problem.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/services/problem.dart';
import 'package:miel_work_app/widgets/problem_list.dart';

class HomeProblemCard extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final Function()? onTap;

  const HomeProblemCard({
    required this.loginProvider,
    required this.homeProvider,
    this.onTap,
    super.key,
  });

  @override
  State<HomeProblemCard> createState() => _HomeProblemCardState();
}

class _HomeProblemCardState extends State<HomeProblemCard> {
  ProblemService problemService = ProblemService();

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
                  'クレーム／要望',
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
                  stream: problemService.streamList(
                    organizationId: widget.loginProvider.organization?.id,
                    processed: false,
                  ),
                  builder: (context, snapshot) {
                    List<ProblemModel> problems = [];
                    DateTime now = DateTime.now();
                    if (snapshot.hasData) {
                      problems = problemService.generateList(
                        data: snapshot.data,
                      );
                    }
                    if (problems.isEmpty) {
                      return const Center(child: Text('処理待ちはありません'));
                    }
                    return Column(
                      children: problems.map((problem) {
                        return ProblemList(problem: problem);
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
