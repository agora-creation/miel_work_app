import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/report.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/report.dart';
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/form_value.dart';
import 'package:provider/provider.dart';

class ReportModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ReportModel report;

  const ReportModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.report,
    super.key,
  });

  @override
  State<ReportModScreen> createState() => _ReportModScreenState();
}

class _ReportModScreenState extends State<ReportModScreen> {
  String workUser1Name = '';
  String workUser1Time = '';
  String workUser2Name = '';
  String workUser2Time = '';
  String workUser3Name = '';
  String workUser3Time = '';
  String workUser4Name = '';
  String workUser4Time = '';
  String workUser5Name = '';
  String workUser5Time = '';
  String workUser6Name = '';
  String workUser6Time = '';
  String workUser7Name = '';
  String workUser7Time = '';
  String workUser8Name = '';
  String workUser8Time = '';
  String workUser9Name = '';
  String workUser9Time = '';
  String workUser10Name = '';
  String workUser10Time = '';
  String workUser11Name = '';
  String workUser11Time = '';
  String workUser12Name = '';
  String workUser12Time = '';
  String workUser13Name = '';
  String workUser13Time = '';
  String workUser14Name = '';
  String workUser14Time = '';
  String workUser15Name = '';
  String workUser15Time = '';
  String workUser16Name = '';
  String workUser16Time = '';

  @override
  void initState() {
    workUser1Name = widget.report.workUser1Name;
    workUser1Time = widget.report.workUser1Time;
    workUser2Name = widget.report.workUser2Name;
    workUser2Time = widget.report.workUser2Time;
    workUser3Name = widget.report.workUser3Name;
    workUser3Time = widget.report.workUser3Time;
    workUser4Name = widget.report.workUser4Name;
    workUser4Time = widget.report.workUser4Time;
    workUser5Name = widget.report.workUser5Name;
    workUser5Time = widget.report.workUser5Time;
    workUser6Name = widget.report.workUser6Name;
    workUser6Time = widget.report.workUser6Time;
    workUser7Name = widget.report.workUser7Name;
    workUser7Time = widget.report.workUser7Time;
    workUser8Name = widget.report.workUser8Name;
    workUser8Time = widget.report.workUser8Time;
    workUser9Name = widget.report.workUser9Name;
    workUser9Time = widget.report.workUser9Time;
    workUser10Name = widget.report.workUser10Name;
    workUser10Time = widget.report.workUser10Time;
    workUser11Name = widget.report.workUser11Name;
    workUser11Time = widget.report.workUser11Time;
    workUser12Name = widget.report.workUser12Name;
    workUser12Time = widget.report.workUser12Time;
    workUser13Name = widget.report.workUser13Name;
    workUser13Time = widget.report.workUser13Time;
    workUser14Name = widget.report.workUser14Name;
    workUser14Time = widget.report.workUser14Time;
    workUser15Name = widget.report.workUser15Name;
    workUser15Time = widget.report.workUser15Time;
    workUser16Name = widget.report.workUser16Name;
    workUser16Time = widget.report.workUser16Time;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.chevronLeft,
            color: kBlackColor,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${dateText('MM月dd日(E)', widget.report.createdAt)}の日報',
          style: const TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => DelReportDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                report: widget.report,
              ),
            ),
            icon: const FaIcon(
              FontAwesomeIcons.trash,
              color: kRedColor,
            ),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '本日の出勤者',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                  ),
                ),
                const Text('インフォメーション'),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('①'),
                        ),
                        FormValue(
                          workUser1Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser1Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser1Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          workUser1Time,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser1Time,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser1Time = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('②'),
                        ),
                        FormValue(
                          workUser2Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser2Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser2Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          workUser2Time,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser2Time,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser2Time = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('③'),
                        ),
                        FormValue(
                          workUser3Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser3Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser3Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          workUser3Time,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser3Time,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser3Time = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('④'),
                        ),
                        FormValue(
                          workUser4Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser4Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser4Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          workUser4Time,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser4Time,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser4Time = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('⑤'),
                        ),
                        FormValue(
                          workUser5Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser5Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser5Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          workUser5Time,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser5Time,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser5Time = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('⑥'),
                        ),
                        FormValue(
                          workUser6Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser6Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser6Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          workUser6Time,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser6Time,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser6Time = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('⑦'),
                        ),
                        FormValue(
                          workUser7Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser7Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser7Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          workUser7Time,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser7Time,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser7Time = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('⑧'),
                        ),
                        FormValue(
                          workUser8Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser8Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser8Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          workUser8Time,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser8Time,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser8Time = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Text('清掃'),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('⑨'),
                        ),
                        FormValue(
                          workUser9Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser9Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser9Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          workUser9Time,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser9Time,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser9Time = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('⑩'),
                        ),
                        FormValue(
                          workUser10Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser10Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser10Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          workUser10Time,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser10Time,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser10Time = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('⑪'),
                        ),
                        FormValue(
                          workUser11Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser11Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser11Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          workUser11Time,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser11Time,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser11Time = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Text('警備'),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('⑫'),
                        ),
                        FormValue(
                          workUser12Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser12Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser12Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          workUser12Time,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser12Time,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser12Time = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('⑬'),
                        ),
                        FormValue(
                          workUser13Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser13Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser13Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          workUser13Time,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser13Time,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser13Time = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('⑭'),
                        ),
                        FormValue(
                          workUser14Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser14Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser14Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          workUser14Time,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser14Time,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser14Time = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Text('自転車整理'),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('⑮'),
                        ),
                        FormValue(
                          workUser15Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser15Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser15Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          workUser15Time,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser15Time,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser15Time = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('⑯'),
                        ),
                        FormValue(
                          workUser16Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser16Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser16Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          workUser16Time,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: workUser16Time,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      workUser16Time = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          String? error = await reportProvider.update(
            report: widget.report,
            workUser1Name: workUser1Name,
            workUser1Time: workUser1Time,
            workUser2Name: workUser2Name,
            workUser2Time: workUser2Time,
            workUser3Name: workUser3Name,
            workUser3Time: workUser3Time,
            workUser4Name: workUser4Name,
            workUser4Time: workUser4Time,
            workUser5Name: workUser5Name,
            workUser5Time: workUser5Time,
            workUser6Name: workUser6Name,
            workUser6Time: workUser6Time,
            workUser7Name: workUser7Name,
            workUser7Time: workUser7Time,
            workUser8Name: workUser8Name,
            workUser8Time: workUser8Time,
            workUser9Name: workUser9Name,
            workUser9Time: workUser9Time,
            workUser10Name: workUser10Name,
            workUser10Time: workUser10Time,
            workUser11Name: workUser11Name,
            workUser11Time: workUser11Time,
            workUser12Name: workUser12Name,
            workUser12Time: workUser12Time,
            workUser13Name: workUser13Name,
            workUser13Time: workUser13Time,
            workUser14Name: workUser14Name,
            workUser14Time: workUser14Time,
            workUser15Name: workUser15Name,
            workUser15Time: workUser15Time,
            workUser16Name: workUser16Name,
            workUser16Time: workUser16Time,
            loginUser: widget.loginProvider.user,
          );
          if (error != null) {
            if (!mounted) return;
            showMessage(context, error, false);
            return;
          }
          if (!mounted) return;
          showMessage(context, '日報が保存されました', true);
          Navigator.pop(context);
        },
        icon: const FaIcon(
          FontAwesomeIcons.floppyDisk,
          color: kWhiteColor,
        ),
        label: const Text(
          '保存する',
          style: TextStyle(color: kWhiteColor),
        ),
      ),
    );
  }
}

class DelReportDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ReportModel report;

  const DelReportDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.report,
    super.key,
  });

  @override
  State<DelReportDialog> createState() => _DelReportDialogState();
}

class _DelReportDialogState extends State<DelReportDialog> {
  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);
    return CustomAlertDialog(
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            Text(
              '本当に削除しますか？',
              style: TextStyle(color: kRedColor),
            ),
          ],
        ),
      ),
      actions: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '削除する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            String? error = await reportProvider.delete(
              report: widget.report,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '日報が削除されました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
