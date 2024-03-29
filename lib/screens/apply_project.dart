import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/apply_project.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/apply_project_add.dart';
import 'package:miel_work_app/screens/apply_project_detail.dart';
import 'package:miel_work_app/services/apply_project.dart';
import 'package:miel_work_app/widgets/custom_apply_project_list.dart';

class ApplyProjectScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ApplyProjectScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ApplyProjectScreen> createState() => _ApplyProjectScreenState();
}

class _ApplyProjectScreenState extends State<ApplyProjectScreen> {
  ApplyProjectService projectService = ApplyProjectService();
  DateTime? searchStart;
  DateTime? searchEnd;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
            '企画申請一覧',
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
          bottom: const TabBar(
            tabs: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('承認待ち'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('承認済み'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('否決'),
              ),
            ],
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 5, color: kBlueColor),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          shape: const Border(bottom: BorderSide(color: kGrey600Color)),
        ),
        body: TabBarView(
          children: [
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: projectService.streamList(
                organizationId: widget.loginProvider.organization?.id,
                approval: 0,
                searchStart: searchStart,
                searchEnd: searchEnd,
              ),
              builder: (context, snapshot) {
                List<ApplyProjectModel> projects = [];
                if (snapshot.hasData) {
                  projects = projectService.generateList(
                    data: snapshot.data,
                    currentGroup: widget.homeProvider.currentGroup,
                  );
                }
                if (projects.isEmpty) {
                  return const Center(child: Text('企画申請はありません'));
                }
                return ListView.builder(
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    ApplyProjectModel project = projects[index];
                    return CustomApplyProjectList(
                      project: project,
                      onTap: () => pushScreen(
                        context,
                        ApplyProjectDetailScreen(
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                          project: project,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: projectService.streamList(
                organizationId: widget.loginProvider.organization?.id,
                approval: 1,
                searchStart: searchStart,
                searchEnd: searchEnd,
              ),
              builder: (context, snapshot) {
                List<ApplyProjectModel> projects = [];
                if (snapshot.hasData) {
                  projects = projectService.generateList(
                    data: snapshot.data,
                    currentGroup: widget.homeProvider.currentGroup,
                  );
                }
                if (projects.isEmpty) {
                  return const Center(child: Text('企画申請はありません'));
                }
                return ListView.builder(
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    ApplyProjectModel project = projects[index];
                    return CustomApplyProjectList(
                      project: project,
                      onTap: () => pushScreen(
                        context,
                        ApplyProjectDetailScreen(
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                          project: project,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: projectService.streamList(
                organizationId: widget.loginProvider.organization?.id,
                approval: 9,
                searchStart: searchStart,
                searchEnd: searchEnd,
              ),
              builder: (context, snapshot) {
                List<ApplyProjectModel> projects = [];
                if (snapshot.hasData) {
                  projects = projectService.generateList(
                    data: snapshot.data,
                    currentGroup: widget.homeProvider.currentGroup,
                  );
                }
                if (projects.isEmpty) {
                  return const Center(child: Text('企画申請はありません'));
                }
                return ListView.builder(
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    ApplyProjectModel project = projects[index];
                    return CustomApplyProjectList(
                      project: project,
                      onTap: () => pushScreen(
                        context,
                        ApplyProjectDetailScreen(
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                          project: project,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => pushScreen(
            context,
            ApplyProjectAddScreen(
              loginProvider: widget.loginProvider,
              homeProvider: widget.homeProvider,
            ),
          ),
          icon: const Icon(
            Icons.add,
            color: kWhiteColor,
          ),
          label: const Text(
            '新規申請',
            style: TextStyle(color: kWhiteColor),
          ),
        ),
      ),
    );
  }
}
