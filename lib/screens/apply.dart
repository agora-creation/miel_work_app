import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/apply.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/apply_add.dart';
import 'package:miel_work_app/screens/apply_detail.dart';
import 'package:miel_work_app/services/apply.dart';
import 'package:miel_work_app/services/config.dart';
import 'package:miel_work_app/widgets/custom_apply_list.dart';

class ApplyScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final String type;

  const ApplyScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.type,
    super.key,
  });

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  ApplyService applyService = ApplyService();
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
    return MediaQuery.withNoTextScaling(
      child: DefaultTabController(
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
            title: Text(
              '${widget.type}申請一覧',
              style: const TextStyle(color: kBlackColor),
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
                stream: applyService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  searchType: widget.type,
                  searchApproval: 0,
                  searchStart: searchStart,
                  searchEnd: searchEnd,
                ),
                builder: (context, snapshot) {
                  List<ApplyModel> applies = [];
                  if (snapshot.hasData) {
                    applies = applyService.generateList(
                      data: snapshot.data,
                      currentGroup: widget.homeProvider.currentGroup,
                    );
                  }
                  if (applies.isEmpty) {
                    return const Center(child: Text('申請はありません'));
                  }
                  return ListView.builder(
                    itemCount: applies.length,
                    itemBuilder: (context, index) {
                      ApplyModel apply = applies[index];
                      return CustomApplyList(
                        apply: apply,
                        onTap: () => pushScreen(
                          context,
                          ApplyDetailScreen(
                            loginProvider: widget.loginProvider,
                            homeProvider: widget.homeProvider,
                            apply: apply,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: applyService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  searchType: widget.type,
                  searchApproval: 1,
                  searchStart: searchStart,
                  searchEnd: searchEnd,
                ),
                builder: (context, snapshot) {
                  List<ApplyModel> applies = [];
                  if (snapshot.hasData) {
                    applies = applyService.generateList(
                      data: snapshot.data,
                      currentGroup: widget.homeProvider.currentGroup,
                    );
                  }
                  if (applies.isEmpty) {
                    return const Center(child: Text('申請はありません'));
                  }
                  return ListView.builder(
                    itemCount: applies.length,
                    itemBuilder: (context, index) {
                      ApplyModel apply = applies[index];
                      return CustomApplyList(
                        apply: apply,
                        onTap: () => pushScreen(
                          context,
                          ApplyDetailScreen(
                            loginProvider: widget.loginProvider,
                            homeProvider: widget.homeProvider,
                            apply: apply,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: applyService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  searchType: widget.type,
                  searchApproval: 9,
                  searchStart: searchStart,
                  searchEnd: searchEnd,
                ),
                builder: (context, snapshot) {
                  List<ApplyModel> applies = [];
                  if (snapshot.hasData) {
                    applies = applyService.generateList(
                      data: snapshot.data,
                      currentGroup: widget.homeProvider.currentGroup,
                    );
                  }
                  if (applies.isEmpty) {
                    return const Center(child: Text('申請はありません'));
                  }
                  return ListView.builder(
                    itemCount: applies.length,
                    itemBuilder: (context, index) {
                      ApplyModel apply = applies[index];
                      return CustomApplyList(
                        apply: apply,
                        onTap: () => pushScreen(
                          context,
                          ApplyDetailScreen(
                            loginProvider: widget.loginProvider,
                            homeProvider: widget.homeProvider,
                            apply: apply,
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
              ApplyAddScreen(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                type: widget.type,
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
      ),
    );
  }
}
