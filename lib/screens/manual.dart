import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/manual.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/manual_add.dart';
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
  DateTime? searchStart;
  DateTime? searchEnd;

  @override
  Widget build(BuildContext context) {
    String appBarTitle = '';
    if (widget.homeProvider.currentGroup != null) {
      appBarTitle = '${widget.homeProvider.currentGroup?.name}の業務マニュアル';
    } else {
      appBarTitle = '全ての業務マニュアル';
    }
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
        title: Text(
          appBarTitle,
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
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: manualService.streamList(
          organizationId: widget.loginProvider.organization?.id,
          searchStart: searchStart,
          searchEnd: searchEnd,
        ),
        builder: (context, snapshot) {
          List<ManualModel> manuals = [];
          if (snapshot.hasData) {
            manuals = manualService.generateList(
              data: snapshot.data,
              currentGroup: widget.homeProvider.currentGroup,
            );
          }
          if (manuals.isEmpty) {
            return const Center(child: Text('業務マニュアルはありません'));
          }
          return ListView.builder(
            itemCount: manuals.length,
            itemBuilder: (context, index) {
              ManualModel manual = manuals[index];
              return CustomManualList(
                manual: manual,
                user: widget.loginProvider.user,
                onTap: () => pushScreen(
                  context,
                  ManualPdfScreen(
                    loginProvider: widget.loginProvider,
                    homeProvider: widget.homeProvider,
                    manual: manual,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: widget.loginProvider.user?.admin == true
          ? FloatingActionButton.extended(
              onPressed: () => pushScreen(
                context,
                ManualAddScreen(
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
            )
          : null,
    );
  }
}
