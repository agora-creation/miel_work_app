import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/apply_conference.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/apply_conference_add.dart';
import 'package:miel_work_app/screens/apply_conference_detail.dart';
import 'package:miel_work_app/services/apply_conference.dart';
import 'package:miel_work_app/widgets/custom_apply_conference_list.dart';

class ApplyConferenceScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ApplyConferenceScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ApplyConferenceScreen> createState() => _ApplyConferenceScreenState();
}

class _ApplyConferenceScreenState extends State<ApplyConferenceScreen> {
  ApplyConferenceService conferenceService = ApplyConferenceService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
            '協議申請一覧',
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
              stream: conferenceService.streamList(
                organizationId: widget.loginProvider.organization?.id,
                approval: false,
              ),
              builder: (context, snapshot) {
                List<ApplyConferenceModel> conferences = [];
                if (snapshot.hasData) {
                  conferences = conferenceService.generateList(
                    data: snapshot.data,
                    currentGroup: widget.homeProvider.currentGroup,
                  );
                }
                if (conferences.isEmpty) {
                  return const Center(child: Text('協議申請はありません'));
                }
                return ListView.builder(
                  itemCount: conferences.length,
                  itemBuilder: (context, index) {
                    ApplyConferenceModel conference = conferences[index];
                    return CustomApplyConferenceList(
                      conference: conference,
                      onTap: () => pushScreen(
                        context,
                        ApplyConferenceDetailScreen(
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                          conference: conference,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: conferenceService.streamList(
                organizationId: widget.loginProvider.organization?.id,
                approval: true,
              ),
              builder: (context, snapshot) {
                List<ApplyConferenceModel> conferences = [];
                if (snapshot.hasData) {
                  conferences = conferenceService.generateList(
                    data: snapshot.data,
                    currentGroup: widget.homeProvider.currentGroup,
                  );
                }
                if (conferences.isEmpty) {
                  return const Center(child: Text('協議申請はありません'));
                }
                return ListView.builder(
                  itemCount: conferences.length,
                  itemBuilder: (context, index) {
                    ApplyConferenceModel conference = conferences[index];
                    return CustomApplyConferenceList(
                      conference: conference,
                      onTap: () => pushScreen(
                        context,
                        ApplyConferenceDetailScreen(
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                          conference: conference,
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
            ApplyConferenceAddScreen(
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
