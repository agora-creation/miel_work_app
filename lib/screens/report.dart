import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/report_add.dart';
import 'package:miel_work_app/services/report.dart';
import 'package:miel_work_app/widgets/month_picker_button.dart';
import 'package:miel_work_app/widgets/report_list.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:page_transition/page_transition.dart';

class ReportScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ReportScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  ReportService reportService = ReportService();
  DateTime searchMonth = DateTime.now();
  List<DateTime> days = [];

  void _changeMonth(DateTime value) {
    searchMonth = value;
    days = generateDays(value);
    setState(() {});
  }

  void _init() {
    days = generateDays(searchMonth);
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhiteColor,
        title: const Text(
          '業務日報',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.xmark,
              color: kBlackColor,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: Column(
        children: [
          MonthPickerButton(
            value: searchMonth,
            onTap: () async {
              DateTime? selected = await showMonthPicker(
                context: context,
                initialDate: searchMonth,
                locale: const Locale(
                  'ja',
                ),
              );
              if (selected == null) return;
              _changeMonth(selected);
            },
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: reportService.streamList(
                organizationId: widget.loginProvider.organization?.id,
                searchStart: null,
                searchEnd: null,
              ),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    DateTime day = days[index];
                    return ReportList(
                      day: day,
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: ReportAddScreen(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              day: day,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
