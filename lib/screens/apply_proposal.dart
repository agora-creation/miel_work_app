import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/apply_proposal.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/apply_proposal_add.dart';
import 'package:miel_work_app/screens/apply_proposal_detail.dart';
import 'package:miel_work_app/services/apply_proposal.dart';
import 'package:miel_work_app/widgets/custom_apply_proposal_list.dart';

class ApplyProposalScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ApplyProposalScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ApplyProposalScreen> createState() => _ApplyProposalScreenState();
}

class _ApplyProposalScreenState extends State<ApplyProposalScreen> {
  ApplyProposalService proposalService = ApplyProposalService();
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
            '稟議申請一覧',
            style: TextStyle(color: kBlackColor),
          ),
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
              stream: proposalService.streamList(
                organizationId: widget.loginProvider.organization?.id,
                approval: 0,
                searchStart: searchStart,
                searchEnd: searchEnd,
              ),
              builder: (context, snapshot) {
                List<ApplyProposalModel> proposals = [];
                if (snapshot.hasData) {
                  proposals = proposalService.generateList(
                    data: snapshot.data,
                    currentGroup: widget.homeProvider.currentGroup,
                  );
                }
                if (proposals.isEmpty) {
                  return const Center(child: Text('稟議申請はありません'));
                }
                return ListView.builder(
                  itemCount: proposals.length,
                  itemBuilder: (context, index) {
                    ApplyProposalModel proposal = proposals[index];
                    return CustomApplyProposalList(
                      proposal: proposal,
                      onTap: () => pushScreen(
                        context,
                        ApplyProposalDetailScreen(
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                          proposal: proposal,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: proposalService.streamList(
                organizationId: widget.loginProvider.organization?.id,
                approval: 1,
                searchStart: searchStart,
                searchEnd: searchEnd,
              ),
              builder: (context, snapshot) {
                List<ApplyProposalModel> proposals = [];
                if (snapshot.hasData) {
                  proposals = proposalService.generateList(
                    data: snapshot.data,
                    currentGroup: widget.homeProvider.currentGroup,
                  );
                }
                if (proposals.isEmpty) {
                  return const Center(child: Text('稟議申請はありません'));
                }
                return ListView.builder(
                  itemCount: proposals.length,
                  itemBuilder: (context, index) {
                    ApplyProposalModel proposal = proposals[index];
                    return CustomApplyProposalList(
                      proposal: proposal,
                      onTap: () => pushScreen(
                        context,
                        ApplyProposalDetailScreen(
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                          proposal: proposal,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: proposalService.streamList(
                organizationId: widget.loginProvider.organization?.id,
                approval: 9,
                searchStart: searchStart,
                searchEnd: searchEnd,
              ),
              builder: (context, snapshot) {
                List<ApplyProposalModel> proposals = [];
                if (snapshot.hasData) {
                  proposals = proposalService.generateList(
                    data: snapshot.data,
                    currentGroup: widget.homeProvider.currentGroup,
                  );
                }
                if (proposals.isEmpty) {
                  return const Center(child: Text('稟議申請はありません'));
                }
                return ListView.builder(
                  itemCount: proposals.length,
                  itemBuilder: (context, index) {
                    ApplyProposalModel proposal = proposals[index];
                    return CustomApplyProposalList(
                      proposal: proposal,
                      onTap: () => pushScreen(
                        context,
                        ApplyProposalDetailScreen(
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                          proposal: proposal,
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
            ApplyProposalAddScreen(
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
