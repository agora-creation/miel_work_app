import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/manual.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/manual_pdf.dart';
import 'package:miel_work_app/services/manual.dart';
import 'package:miel_work_app/widgets/custom_manual_list.dart';

class ManualScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ManualScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ManualScreen> createState() => _ManualScreenState();
}

class _ManualScreenState extends State<ManualScreen> {
  ManualService manualService = ManualService();

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
          '業務マニュアル一覧',
          style: TextStyle(color: kBlackColor),
        ),
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: manualService.streamList(
          organizationId: widget.loginProvider.organization?.id,
        ),
        builder: (context, snapshot) {
          List<ManualModel> manuals = [];
          if (snapshot.hasData) {
            for (DocumentSnapshot<Map<String, dynamic>> doc
                in snapshot.data!.docs) {
              ManualModel manual = ManualModel.fromSnapshot(doc);
              OrganizationGroupModel? group = widget.homeProvider.currentGroup;
              if (group == null) {
                manuals.add(manual);
              } else if (manual.groupId == group.id || manual.groupId == '') {
                manuals.add(manual);
              }
            }
          }
          return ListView.builder(
            itemCount: manuals.length,
            itemBuilder: (context, index) {
              ManualModel manual = manuals[index];
              return CustomManualList(
                manual: manual,
                onTap: () => pushScreen(
                  context,
                  ManualPdfScreen(manual: manual),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: widget.loginProvider.isAdmin()
          ? FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add, color: kWhiteColor),
            )
          : Container(),
    );
  }
}
