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
  bool searchApproval = false;

  void _searchApprovalChange(bool value) {
    setState(() {
      searchApproval = value;
    });
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
          '協議申請一覧',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => ApprovalSelectDialog(
                searchApproval: searchApproval,
                searchApprovalChange: _searchApprovalChange,
              ),
            ),
            icon: const Icon(Icons.search),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: conferenceService.streamList(
          organizationId: widget.loginProvider.organization?.id,
          approval: searchApproval,
        ),
        builder: (context, snapshot) {
          List<ApplyConferenceModel> conferences = [];
          if (snapshot.hasData) {
            conferences = conferenceService.generateList(
              data: snapshot.data,
              currentGroup: widget.homeProvider.currentGroup,
            );
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => pushScreen(
          context,
          ApplyConferenceAddScreen(
            loginProvider: widget.loginProvider,
            homeProvider: widget.homeProvider,
          ),
        ),
        child: const Icon(Icons.add, color: kWhiteColor),
      ),
    );
  }
}

class ApprovalSelectDialog extends StatefulWidget {
  final bool searchApproval;
  final Function(bool) searchApprovalChange;

  const ApprovalSelectDialog({
    required this.searchApproval,
    required this.searchApprovalChange,
    super.key,
  });

  @override
  State<ApprovalSelectDialog> createState() => _ApprovalSelectDialogState();
}

class _ApprovalSelectDialogState extends State<ApprovalSelectDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      content: Container(
        decoration: BoxDecoration(border: Border.all(color: kGrey600Color)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: kGrey600Color)),
                ),
                child: RadioListTile<bool>(
                  title: const Text('承認待ち'),
                  value: false,
                  groupValue: widget.searchApproval,
                  onChanged: (value) {
                    widget.searchApprovalChange(value ?? false);
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: kGrey600Color)),
                ),
                child: RadioListTile<bool>(
                  title: const Text('承認済み'),
                  value: true,
                  groupValue: widget.searchApproval,
                  onChanged: (value) {
                    widget.searchApprovalChange(value ?? false);
                    Navigator.pop(context);
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
