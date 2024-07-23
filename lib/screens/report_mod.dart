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
  String visitCount1_12 = '';
  String visitCount1_20 = '';
  String visitCount1_22 = '';
  String visitCount2_12 = '';
  String visitCount2_20 = '';
  String visitCount2_22 = '';
  String visitCount3_12 = '';
  String visitCount3_20 = '';
  String visitCount3_22 = '';
  String visitCount4_12 = '';
  String visitCount4_20 = '';
  String visitCount4_22 = '';
  String visitCount5_12 = '';
  String visitCount5_20 = '';
  String visitCount5_22 = '';
  String visitCount6_12 = '';
  String visitCount6_20 = '';
  String visitCount6_22 = '';
  String lockerUse = '';
  String lockerLost = '';
  String lockerRecovery = '';
  String event1 = '';
  String event2 = '';
  String marketing = '';
  String interview = '';
  String openSquare = '';
  String openSquareFee = '';
  String openSquareStatus = '';
  String meeting = '';
  String mailCheck10Name = '';
  String mailCheck10Status = '';
  String mailCheck12Name = '';
  String mailCheck12Status = '';
  String mailCheck18Name = '';
  String mailCheck18Status = '';
  String mailCheck22Name = '';
  String mailCheck22Status = '';
  String warning19Status = '';
  String warning19Deal = '';
  String warning23Status = '';
  String warning23Deal = '';
  String advance1 = '';
  String advance2 = '';
  String advance3 = '';
  String repair = '';
  String repairStatus = '';
  String repairDeal = '';
  String problem = '';
  String problemDeal = '';
  String pamphlet1Status = '';
  String pamphlet1Name = '';
  String pamphlet1Fee = '';
  String pamphlet2Status = '';
  String pamphlet2Name = '';
  String pamphlet2Fee = '';
  String pamphlet3Status = '';
  String pamphlet3Name = '';
  String pamphlet3Fee = '';
  String pamphlet4Status = '';
  String pamphlet4Name = '';
  String pamphlet4Fee = '';
  String pamphlet5Status = '';
  String pamphlet5Name = '';
  String pamphlet5Fee = '';
  String pamphlet6Status = '';
  String pamphlet6Name = '';
  String pamphlet6Fee = '';
  String pamphlet7Status = '';
  String pamphlet7Name = '';
  String pamphlet7Fee = '';
  String equipment1Type = '';
  String equipment1Name = '';
  String equipment1Vendor = '';
  String equipment1Delivery = '';
  String equipment1Client = '';
  String equipment2Type = '';
  String equipment2Name = '';
  String equipment2Vendor = '';
  String equipment2Delivery = '';
  String equipment2Client = '';
  String equipment3Type = '';
  String equipment3Name = '';
  String equipment3Vendor = '';
  String equipment3Delivery = '';
  String equipment3Client = '';
  String equipment4Type = '';
  String equipment4Name = '';
  String equipment4Vendor = '';
  String equipment4Delivery = '';
  String equipment4Client = '';
  String equipment5Type = '';
  String equipment5Name = '';
  String equipment5Vendor = '';
  String equipment5Delivery = '';
  String equipment5Client = '';
  String equipment6Type = '';
  String equipment6Name = '';
  String equipment6Vendor = '';
  String equipment6Delivery = '';
  String equipment6Client = '';
  String contact = '';
  String lastConfirm = '';
  String agenda = '';
  String confirm1 = '';
  String confirm2 = '';
  String confirm3 = '';
  String confirm4 = '';
  String confirm5 = '';
  String confirm6 = '';
  String confirm7 = '';
  String confirm8 = '';
  String confirm9 = '';
  String confirm10 = '';
  String confirm11 = '';
  String confirm12 = '';
  String passport = '';
  String passportCount1 = '';
  String passportCount2 = '';
  String passportCount3 = '';

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
    visitCount1_12 = widget.report.visitCount1_12;
    visitCount1_20 = widget.report.visitCount1_20;
    visitCount1_22 = widget.report.visitCount1_22;
    visitCount2_12 = widget.report.visitCount2_12;
    visitCount2_20 = widget.report.visitCount2_20;
    visitCount2_22 = widget.report.visitCount2_22;
    visitCount3_12 = widget.report.visitCount3_12;
    visitCount3_20 = widget.report.visitCount3_20;
    visitCount3_22 = widget.report.visitCount3_22;
    visitCount4_12 = widget.report.visitCount4_12;
    visitCount4_20 = widget.report.visitCount4_20;
    visitCount4_22 = widget.report.visitCount4_22;
    visitCount5_12 = widget.report.visitCount5_12;
    visitCount5_20 = widget.report.visitCount5_20;
    visitCount5_22 = widget.report.visitCount5_22;
    visitCount6_12 = widget.report.visitCount6_12;
    visitCount6_20 = widget.report.visitCount6_20;
    visitCount6_22 = widget.report.visitCount6_22;
    lockerUse = widget.report.lockerUse;
    lockerLost = widget.report.lockerLost;
    lockerRecovery = widget.report.lockerRecovery;
    event1 = widget.report.event1;
    event2 = widget.report.event2;
    marketing = widget.report.marketing;
    interview = widget.report.interview;
    openSquare = widget.report.openSquare;
    openSquareFee = widget.report.openSquareFee;
    openSquareStatus = widget.report.openSquareStatus;
    meeting = widget.report.meeting;
    mailCheck10Name = widget.report.mailCheck10Name;
    mailCheck10Status = widget.report.mailCheck10Status;
    mailCheck12Name = widget.report.mailCheck12Name;
    mailCheck12Status = widget.report.mailCheck12Status;
    mailCheck18Name = widget.report.mailCheck18Name;
    mailCheck18Status = widget.report.mailCheck18Status;
    mailCheck22Name = widget.report.mailCheck22Name;
    mailCheck22Status = widget.report.mailCheck22Status;
    warning19Status = widget.report.warning19Status;
    warning19Deal = widget.report.warning19Deal;
    warning23Status = widget.report.warning23Status;
    warning23Deal = widget.report.warning23Deal;
    advance1 = widget.report.advance1;
    advance2 = widget.report.advance2;
    advance3 = widget.report.advance3;
    repair = widget.report.repair;
    repairStatus = widget.report.repairStatus;
    repairDeal = widget.report.repairDeal;
    problem = widget.report.problem;
    problemDeal = widget.report.problemDeal;
    pamphlet1Status = widget.report.pamphlet1Status;
    pamphlet1Name = widget.report.pamphlet1Name;
    pamphlet1Fee = widget.report.pamphlet1Fee;
    pamphlet2Status = widget.report.pamphlet2Status;
    pamphlet2Name = widget.report.pamphlet2Name;
    pamphlet2Fee = widget.report.pamphlet2Fee;
    pamphlet3Status = widget.report.pamphlet3Status;
    pamphlet3Name = widget.report.pamphlet3Name;
    pamphlet3Fee = widget.report.pamphlet3Fee;
    pamphlet4Status = widget.report.pamphlet4Status;
    pamphlet4Name = widget.report.pamphlet4Name;
    pamphlet4Fee = widget.report.pamphlet4Fee;
    pamphlet5Status = widget.report.pamphlet5Status;
    pamphlet5Name = widget.report.pamphlet5Name;
    pamphlet5Fee = widget.report.pamphlet5Fee;
    pamphlet6Status = widget.report.pamphlet6Status;
    pamphlet6Name = widget.report.pamphlet6Name;
    pamphlet6Fee = widget.report.pamphlet6Fee;
    pamphlet7Status = widget.report.pamphlet7Status;
    pamphlet7Name = widget.report.pamphlet7Name;
    pamphlet7Fee = widget.report.pamphlet7Fee;
    equipment1Type = widget.report.equipment1Type;
    equipment1Name = widget.report.equipment1Name;
    equipment1Vendor = widget.report.equipment1Vendor;
    equipment1Delivery = widget.report.equipment1Delivery;
    equipment1Client = widget.report.equipment1Client;
    equipment2Type = widget.report.equipment2Type;
    equipment2Name = widget.report.equipment2Name;
    equipment2Vendor = widget.report.equipment2Vendor;
    equipment2Delivery = widget.report.equipment2Delivery;
    equipment2Client = widget.report.equipment2Client;
    equipment3Type = widget.report.equipment3Type;
    equipment3Name = widget.report.equipment3Name;
    equipment3Vendor = widget.report.equipment3Vendor;
    equipment3Delivery = widget.report.equipment3Delivery;
    equipment3Client = widget.report.equipment3Client;
    equipment4Type = widget.report.equipment4Type;
    equipment4Name = widget.report.equipment4Name;
    equipment4Vendor = widget.report.equipment4Vendor;
    equipment4Delivery = widget.report.equipment4Delivery;
    equipment4Client = widget.report.equipment4Client;
    equipment5Type = widget.report.equipment5Type;
    equipment5Name = widget.report.equipment5Name;
    equipment5Vendor = widget.report.equipment5Vendor;
    equipment5Delivery = widget.report.equipment5Delivery;
    equipment5Client = widget.report.equipment5Client;
    equipment6Type = widget.report.equipment6Type;
    equipment6Name = widget.report.equipment6Name;
    equipment6Vendor = widget.report.equipment6Vendor;
    equipment6Delivery = widget.report.equipment6Delivery;
    equipment6Client = widget.report.equipment6Client;
    contact = widget.report.contact;
    lastConfirm = widget.report.lastConfirm;
    agenda = widget.report.agenda;
    confirm1 = widget.report.confirm1;
    confirm2 = widget.report.confirm2;
    confirm3 = widget.report.confirm3;
    confirm4 = widget.report.confirm4;
    confirm5 = widget.report.confirm5;
    confirm6 = widget.report.confirm6;
    confirm7 = widget.report.confirm7;
    confirm8 = widget.report.confirm8;
    confirm9 = widget.report.confirm9;
    confirm10 = widget.report.confirm10;
    confirm11 = widget.report.confirm11;
    confirm12 = widget.report.confirm12;
    passport = widget.report.passport;
    passportCount1 = widget.report.passportCount1;
    passportCount2 = widget.report.passportCount2;
    passportCount3 = widget.report.passportCount3;
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
                const SizedBox(height: 16),
                const Text(
                  '入場者数カウント',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                  ),
                ),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                  },
                  children: [
                    const TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(''),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('12:30'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('20:00'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('22:00'),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('お城下広場'),
                        ),
                        FormValue(
                          visitCount1_12,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: visitCount1_12,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      visitCount1_12 = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          visitCount1_20,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: visitCount1_20,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      visitCount1_20 = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          visitCount1_22,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: visitCount1_22,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      visitCount1_22 = value;
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
                          child: Text('いごっそう'),
                        ),
                        FormValue(
                          visitCount2_12,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: visitCount2_12,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      visitCount2_12 = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          visitCount2_20,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: visitCount2_20,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      visitCount2_20 = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          visitCount2_22,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: visitCount2_22,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      visitCount2_22 = value;
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
                          child: Text('自由広場'),
                        ),
                        FormValue(
                          visitCount3_12,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: visitCount3_12,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      visitCount3_12 = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          visitCount3_20,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: visitCount3_20,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      visitCount3_20 = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          visitCount3_22,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: visitCount3_22,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      visitCount3_22 = value;
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
                          child: Text('東通路(バル)'),
                        ),
                        FormValue(
                          visitCount4_12,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: visitCount4_12,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      visitCount4_12 = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          visitCount4_20,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: visitCount4_20,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      visitCount4_20 = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          visitCount4_22,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: visitCount4_22,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      visitCount4_22 = value;
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
                          child: Text('計'),
                        ),
                        FormValue(
                          visitCount5_12,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: visitCount5_12,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      visitCount5_12 = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          visitCount5_20,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: visitCount5_20,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      visitCount5_20 = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          visitCount5_22,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: visitCount5_22,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      visitCount5_22 = value;
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
                          child: Text('前年同曜日'),
                        ),
                        FormValue(
                          visitCount6_12,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: visitCount6_12,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      visitCount6_12 = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          visitCount6_20,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: visitCount6_20,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      visitCount6_20 = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          visitCount6_22,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: visitCount6_22,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      visitCount6_22 = value;
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
                const SizedBox(height: 16),
                const Text(
                  'コインロッカー',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                  ),
                ),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(1),
                    2: IntrinsicColumnWidth(),
                    3: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('連続使用'),
                        ),
                        FormValue(
                          lockerUse,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile(
                                    title: const Text('無'),
                                    value: '無',
                                    groupValue: lockerUse,
                                    onChanged: (value) {
                                      lockerUse = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('有'),
                                    value: '有',
                                    groupValue: lockerUse,
                                    onChanged: (value) {
                                      lockerUse = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('忘れ物'),
                        ),
                        FormValue(
                          lockerLost,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile(
                                    title: const Text('無'),
                                    value: '無',
                                    groupValue: lockerLost,
                                    onChanged: (value) {
                                      lockerLost = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('有'),
                                    value: '有',
                                    groupValue: lockerLost,
                                    onChanged: (value) {
                                      lockerLost = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
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
                const SizedBox(height: 4),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('回収'),
                        ),
                        FormValue(
                          lockerRecovery,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: lockerRecovery,
                                    ),
                                    textInputType: TextInputType.multiline,
                                    maxLines: null,
                                    onChanged: (value) {
                                      lockerRecovery = value;
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
                const SizedBox(height: 16),
                const Text(
                  'イベント',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                  ),
                ),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  children: [
                    const TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('主'),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        FormValue(
                          event1,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: event1,
                                    ),
                                    textInputType: TextInputType.multiline,
                                    maxLines: null,
                                    onChanged: (value) {
                                      event1 = value;
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
                    const TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('周辺'),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        FormValue(
                          event2,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: event2,
                                    ),
                                    textInputType: TextInputType.multiline,
                                    maxLines: null,
                                    onChanged: (value) {
                                      event2 = value;
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
                const SizedBox(height: 16),
                const Text(
                  '集客',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                  ),
                ),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  children: [
                    TableRow(
                      children: [
                        FormValue(
                          marketing,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: marketing,
                                    ),
                                    textInputType: TextInputType.multiline,
                                    maxLines: null,
                                    onChanged: (value) {
                                      marketing = value;
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
                const SizedBox(height: 16),
                const Text(
                  '取材・視察',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                  ),
                ),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  children: [
                    TableRow(
                      children: [
                        FormValue(
                          interview,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: interview,
                                    ),
                                    textInputType: TextInputType.multiline,
                                    maxLines: null,
                                    onChanged: (value) {
                                      interview = value;
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
                const SizedBox(height: 16),
                const Text(
                  '広場出店',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                  ),
                ),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  children: [
                    TableRow(
                      children: [
                        FormValue(
                          openSquare,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: openSquare,
                                    ),
                                    textInputType: TextInputType.multiline,
                                    maxLines: null,
                                    onChanged: (value) {
                                      openSquare = value;
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
                const SizedBox(height: 4),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  children: [
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('使用料'),
                        ),
                        FormValue(
                          openSquareFee,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: openSquareFee,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      openSquareFee = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('入金状況'),
                        ),
                        FormValue(
                          openSquareStatus,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile(
                                    title: const Text('未入金'),
                                    value: '未入金',
                                    groupValue: openSquareStatus,
                                    onChanged: (value) {
                                      openSquareStatus = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('入金済'),
                                    value: '入金済',
                                    groupValue: openSquareStatus,
                                    onChanged: (value) {
                                      openSquareStatus = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
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
                const SizedBox(height: 16),
                const Text(
                  '打合せ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                  ),
                ),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  children: [
                    TableRow(
                      children: [
                        FormValue(
                          meeting,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: meeting,
                                    ),
                                    textInputType: TextInputType.multiline,
                                    maxLines: null,
                                    onChanged: (value) {
                                      meeting = value;
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
                const SizedBox(height: 16),
                const Text(
                  'メールチェック',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                  ),
                ),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('10:30'),
                        ),
                        FormValue(
                          mailCheck10Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: mailCheck10Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      mailCheck10Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          mailCheck10Status,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile(
                                    title: const Text('未対応'),
                                    value: '未対応',
                                    groupValue: mailCheck10Status,
                                    onChanged: (value) {
                                      mailCheck10Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('対応済'),
                                    value: '対応済',
                                    groupValue: mailCheck10Status,
                                    onChanged: (value) {
                                      mailCheck10Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
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
                          child: Text('12:00'),
                        ),
                        FormValue(
                          mailCheck12Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: mailCheck12Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      mailCheck12Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          mailCheck12Status,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile(
                                    title: const Text('未対応'),
                                    value: '未対応',
                                    groupValue: mailCheck12Status,
                                    onChanged: (value) {
                                      mailCheck12Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('対応済'),
                                    value: '対応済',
                                    groupValue: mailCheck12Status,
                                    onChanged: (value) {
                                      mailCheck12Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
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
                          child: Text('18:00'),
                        ),
                        FormValue(
                          mailCheck18Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: mailCheck18Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      mailCheck18Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          mailCheck18Status,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile(
                                    title: const Text('未対応'),
                                    value: '未対応',
                                    groupValue: mailCheck18Status,
                                    onChanged: (value) {
                                      mailCheck18Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('対応済'),
                                    value: '対応済',
                                    groupValue: mailCheck18Status,
                                    onChanged: (value) {
                                      mailCheck18Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
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
                          child: Text('22:00'),
                        ),
                        FormValue(
                          mailCheck22Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: mailCheck22Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      mailCheck22Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          mailCheck22Status,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile(
                                    title: const Text('未対応'),
                                    value: '未対応',
                                    groupValue: mailCheck22Status,
                                    onChanged: (value) {
                                      mailCheck22Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('対応済'),
                                    value: '対応済',
                                    groupValue: mailCheck22Status,
                                    onChanged: (value) {
                                      mailCheck22Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
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
                const SizedBox(height: 16),
                const Text(
                  '警戒',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                  ),
                ),
                const Text('19:45～'),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('状態'),
                        ),
                        FormValue(
                          warning19Status,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: warning19Status,
                                    ),
                                    textInputType: TextInputType.multiline,
                                    maxLines: null,
                                    onChanged: (value) {
                                      warning19Status = value;
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
                          child: Text('対処'),
                        ),
                        FormValue(
                          warning19Deal,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: warning19Deal,
                                    ),
                                    textInputType: TextInputType.multiline,
                                    maxLines: null,
                                    onChanged: (value) {
                                      warning19Deal = value;
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
                const SizedBox(height: 4),
                const Text('23:00～'),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('状態'),
                        ),
                        FormValue(
                          warning23Status,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: warning23Status,
                                    ),
                                    textInputType: TextInputType.multiline,
                                    maxLines: null,
                                    onChanged: (value) {
                                      warning23Status = value;
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
                          child: Text('対処'),
                        ),
                        FormValue(
                          warning23Deal,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: warning23Deal,
                                    ),
                                    textInputType: TextInputType.multiline,
                                    maxLines: null,
                                    onChanged: (value) {
                                      warning23Deal = value;
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
                const SizedBox(height: 16),
                const Text(
                  '立替',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                  ),
                ),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('立替'),
                        ),
                        FormValue(
                          advance1,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: advance1,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      advance1 = value;
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
                          child: Text('現金'),
                        ),
                        FormValue(
                          advance2,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: advance2,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      advance2 = value;
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
                          child: Text('合計'),
                        ),
                        FormValue(
                          advance3,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: advance3,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      advance3 = value;
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
                const SizedBox(height: 16),
                const Text(
                  '営繕ヶ所等',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                  ),
                ),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  children: [
                    TableRow(
                      children: [
                        FormValue(
                          repair,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: repair,
                                    ),
                                    textInputType: TextInputType.multiline,
                                    maxLines: null,
                                    onChanged: (value) {
                                      repair = value;
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
                const SizedBox(height: 16),
                const Text(
                  '状態',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                  ),
                ),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  children: [
                    TableRow(
                      children: [
                        FormValue(
                          repairStatus,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: repairStatus,
                                    ),
                                    textInputType: TextInputType.multiline,
                                    maxLines: null,
                                    onChanged: (value) {
                                      repairStatus = value;
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
                const SizedBox(height: 16),
                const Text(
                  '対処・修理・結果',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                  ),
                ),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  children: [
                    TableRow(
                      children: [
                        FormValue(
                          repairDeal,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: repairDeal,
                                    ),
                                    textInputType: TextInputType.multiline,
                                    maxLines: null,
                                    onChanged: (value) {
                                      repairDeal = value;
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
                const SizedBox(height: 16),
                const Text(
                  '苦情・要望・問題',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                  ),
                ),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  children: [
                    TableRow(
                      children: [
                        FormValue(
                          problem,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: problem,
                                    ),
                                    textInputType: TextInputType.multiline,
                                    maxLines: null,
                                    onChanged: (value) {
                                      problem = value;
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
                const SizedBox(height: 16),
                const Text(
                  '対処・対応策',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                  ),
                ),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  children: [
                    TableRow(
                      children: [
                        FormValue(
                          problemDeal,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: problemDeal,
                                    ),
                                    textInputType: TextInputType.multiline,
                                    maxLines: null,
                                    onChanged: (value) {
                                      problemDeal = value;
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
                const SizedBox(height: 16),
                const Text(
                  'パンフレット',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                  ),
                ),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('①'),
                        ),
                        FormValue(
                          pamphlet1Status,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile(
                                    title: const Text('出'),
                                    value: '出',
                                    groupValue: pamphlet1Status,
                                    onChanged: (value) {
                                      pamphlet1Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('入'),
                                    value: '入',
                                    groupValue: pamphlet1Status,
                                    onChanged: (value) {
                                      pamphlet1Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('注'),
                                    value: '注',
                                    groupValue: pamphlet1Status,
                                    onChanged: (value) {
                                      pamphlet1Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          pamphlet1Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: pamphlet1Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      pamphlet1Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          pamphlet1Fee,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: pamphlet1Fee,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      pamphlet1Fee = value;
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
                          pamphlet2Status,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile(
                                    title: const Text('出'),
                                    value: '出',
                                    groupValue: pamphlet2Status,
                                    onChanged: (value) {
                                      pamphlet2Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('入'),
                                    value: '入',
                                    groupValue: pamphlet2Status,
                                    onChanged: (value) {
                                      pamphlet2Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('注'),
                                    value: '注',
                                    groupValue: pamphlet2Status,
                                    onChanged: (value) {
                                      pamphlet2Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          pamphlet2Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: pamphlet2Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      pamphlet2Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          pamphlet2Fee,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: pamphlet2Fee,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      pamphlet2Fee = value;
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
                          pamphlet3Status,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile(
                                    title: const Text('出'),
                                    value: '出',
                                    groupValue: pamphlet3Status,
                                    onChanged: (value) {
                                      pamphlet3Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('入'),
                                    value: '入',
                                    groupValue: pamphlet3Status,
                                    onChanged: (value) {
                                      pamphlet3Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('注'),
                                    value: '注',
                                    groupValue: pamphlet3Status,
                                    onChanged: (value) {
                                      pamphlet3Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          pamphlet3Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: pamphlet3Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      pamphlet3Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          pamphlet3Fee,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: pamphlet3Fee,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      pamphlet3Fee = value;
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
                          pamphlet4Status,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile(
                                    title: const Text('出'),
                                    value: '出',
                                    groupValue: pamphlet4Status,
                                    onChanged: (value) {
                                      pamphlet4Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('入'),
                                    value: '入',
                                    groupValue: pamphlet4Status,
                                    onChanged: (value) {
                                      pamphlet4Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('注'),
                                    value: '注',
                                    groupValue: pamphlet4Status,
                                    onChanged: (value) {
                                      pamphlet4Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          pamphlet4Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: pamphlet4Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      pamphlet4Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          pamphlet4Fee,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: pamphlet4Fee,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      pamphlet4Fee = value;
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
                          pamphlet5Status,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile(
                                    title: const Text('出'),
                                    value: '出',
                                    groupValue: pamphlet5Status,
                                    onChanged: (value) {
                                      pamphlet5Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('入'),
                                    value: '入',
                                    groupValue: pamphlet5Status,
                                    onChanged: (value) {
                                      pamphlet5Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('注'),
                                    value: '注',
                                    groupValue: pamphlet5Status,
                                    onChanged: (value) {
                                      pamphlet5Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          pamphlet5Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: pamphlet5Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      pamphlet5Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          pamphlet5Fee,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: pamphlet5Fee,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      pamphlet5Fee = value;
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
                          pamphlet6Status,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile(
                                    title: const Text('出'),
                                    value: '出',
                                    groupValue: pamphlet6Status,
                                    onChanged: (value) {
                                      pamphlet6Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('入'),
                                    value: '入',
                                    groupValue: pamphlet6Status,
                                    onChanged: (value) {
                                      pamphlet6Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('注'),
                                    value: '注',
                                    groupValue: pamphlet6Status,
                                    onChanged: (value) {
                                      pamphlet6Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          pamphlet6Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: pamphlet6Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      pamphlet6Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          pamphlet6Fee,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: pamphlet6Fee,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      pamphlet6Fee = value;
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
                          pamphlet7Status,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile(
                                    title: const Text('出'),
                                    value: '出',
                                    groupValue: pamphlet7Status,
                                    onChanged: (value) {
                                      pamphlet7Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('入'),
                                    value: '入',
                                    groupValue: pamphlet7Status,
                                    onChanged: (value) {
                                      pamphlet7Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('注'),
                                    value: '注',
                                    groupValue: pamphlet7Status,
                                    onChanged: (value) {
                                      pamphlet7Status = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          pamphlet7Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: pamphlet7Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      pamphlet7Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          pamphlet7Fee,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: pamphlet7Fee,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      pamphlet7Fee = value;
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
                const SizedBox(height: 16),
                const Text(
                  '備品発注・入荷',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                  ),
                ),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                    4: FlexColumnWidth(1),
                    5: FlexColumnWidth(1),
                  },
                  children: [
                    const TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(''),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('発注／入荷'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('品名'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('業者'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('納期(納入数)'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('発注者'),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('①'),
                        ),
                        FormValue(
                          equipment1Type,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile(
                                    title: const Text('発注'),
                                    value: '発注',
                                    groupValue: equipment1Type,
                                    onChanged: (value) {
                                      equipment1Type = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('入荷'),
                                    value: '入荷',
                                    groupValue: equipment1Type,
                                    onChanged: (value) {
                                      equipment1Type = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          equipment1Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: equipment1Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      equipment1Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          equipment1Vendor,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: equipment1Vendor,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      equipment1Vendor = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          equipment1Delivery,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: equipment1Delivery,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      equipment1Delivery = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          equipment1Client,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: equipment1Client,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      equipment1Client = value;
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
                          equipment2Type,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile(
                                    title: const Text('発注'),
                                    value: '発注',
                                    groupValue: equipment2Type,
                                    onChanged: (value) {
                                      equipment2Type = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('入荷'),
                                    value: '入荷',
                                    groupValue: equipment2Type,
                                    onChanged: (value) {
                                      equipment2Type = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          equipment2Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: equipment2Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      equipment2Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          equipment2Vendor,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: equipment2Vendor,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      equipment2Vendor = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          equipment2Delivery,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: equipment2Delivery,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      equipment2Delivery = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          equipment2Client,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: equipment2Client,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      equipment2Client = value;
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
                          equipment3Type,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile(
                                    title: const Text('発注'),
                                    value: '発注',
                                    groupValue: equipment3Type,
                                    onChanged: (value) {
                                      equipment3Type = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('入荷'),
                                    value: '入荷',
                                    groupValue: equipment3Type,
                                    onChanged: (value) {
                                      equipment3Type = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          equipment3Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: equipment3Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      equipment3Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          equipment3Vendor,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: equipment3Vendor,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      equipment3Vendor = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          equipment3Delivery,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: equipment3Delivery,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      equipment3Delivery = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          equipment3Client,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: equipment3Client,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      equipment3Client = value;
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
                          equipment4Type,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile(
                                    title: const Text('発注'),
                                    value: '発注',
                                    groupValue: equipment4Type,
                                    onChanged: (value) {
                                      equipment4Type = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('入荷'),
                                    value: '入荷',
                                    groupValue: equipment4Type,
                                    onChanged: (value) {
                                      equipment4Type = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          equipment4Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: equipment4Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      equipment4Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          equipment4Vendor,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: equipment4Vendor,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      equipment4Vendor = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          equipment4Delivery,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: equipment4Delivery,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      equipment4Delivery = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          equipment4Client,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: equipment4Client,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      equipment4Client = value;
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
                          equipment5Type,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile(
                                    title: const Text('発注'),
                                    value: '発注',
                                    groupValue: equipment5Type,
                                    onChanged: (value) {
                                      equipment5Type = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('入荷'),
                                    value: '入荷',
                                    groupValue: equipment5Type,
                                    onChanged: (value) {
                                      equipment5Type = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          equipment5Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: equipment5Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      equipment5Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          equipment5Vendor,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: equipment5Vendor,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      equipment5Vendor = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          equipment5Delivery,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: equipment5Delivery,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      equipment5Delivery = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          equipment5Client,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: equipment5Client,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      equipment5Client = value;
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
                          equipment6Type,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile(
                                    title: const Text('発注'),
                                    value: '発注',
                                    groupValue: equipment6Type,
                                    onChanged: (value) {
                                      equipment6Type = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text('入荷'),
                                    value: '入荷',
                                    groupValue: equipment6Type,
                                    onChanged: (value) {
                                      equipment6Type = value ?? '';
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          equipment6Name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: equipment6Name,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      equipment6Name = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          equipment6Vendor,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: equipment6Vendor,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      equipment6Vendor = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          equipment6Delivery,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: equipment6Delivery,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      equipment6Delivery = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormValue(
                          equipment6Client,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: equipment6Client,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      equipment6Client = value;
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
                const SizedBox(height: 16),
                const Text(
                  '報告・連絡',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                  ),
                ),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  children: [
                    TableRow(
                      children: [
                        FormValue(
                          contact,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: contact,
                                    ),
                                    textInputType: TextInputType.multiline,
                                    maxLines: null,
                                    onChanged: (value) {
                                      contact = value;
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
                const SizedBox(height: 4),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('日報最終確認'),
                        ),
                        FormValue(
                          lastConfirm,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: lastConfirm,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      lastConfirm = value;
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
                const SizedBox(height: 16),
                const Text(
                  '申送り事項',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                  ),
                ),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  children: [
                    TableRow(
                      children: [
                        FormValue(
                          agenda,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: agenda,
                                    ),
                                    textInputType: TextInputType.multiline,
                                    maxLines: null,
                                    onChanged: (value) {
                                      agenda = value;
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
                const SizedBox(height: 16),
                const Text(
                  '確認',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                  ),
                ),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('最終店舗最終終了時刻'),
                        ),
                        FormValue(
                          confirm1,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: confirm1,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      confirm1 = value;
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
                          child: Text('食器センター終了'),
                        ),
                        FormValue(
                          confirm2,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: confirm2,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      confirm2 = value;
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
                          child: Text('排気'),
                        ),
                        FormValue(
                          confirm3,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: confirm3,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      confirm3 = value;
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
                          child: Text('天井扇SW'),
                        ),
                        FormValue(
                          confirm4,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: confirm4,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      confirm4 = value;
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
                          child: Text('空調SW'),
                        ),
                        FormValue(
                          confirm5,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: confirm5,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      confirm5 = value;
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
                          child: Text('トイレ確認'),
                        ),
                        FormValue(
                          confirm6,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: confirm6,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      confirm6 = value;
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
                          child: Text('ベビーコーナー'),
                        ),
                        FormValue(
                          confirm7,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: confirm7,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      confirm7 = value;
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
                          child: Text('PC・ゴミ'),
                        ),
                        FormValue(
                          confirm8,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: confirm8,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      confirm8 = value;
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
                          child: Text('留守電'),
                        ),
                        FormValue(
                          confirm9,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: confirm9,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      confirm9 = value;
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
                          child: Text('クーポン券確認'),
                        ),
                        FormValue(
                          confirm10,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: confirm10,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      confirm10 = value;
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
                          child: Text('日付確認'),
                        ),
                        FormValue(
                          confirm11,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: confirm11,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      confirm11 = value;
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
                          child: Text('両替確認'),
                        ),
                        FormValue(
                          confirm12,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: confirm12,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      confirm12 = value;
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
                const SizedBox(height: 16),
                const Text(
                  'パスポート押印',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceHanSansJP-Bold',
                  ),
                ),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  children: [
                    TableRow(
                      children: [
                        FormValue(
                          passport,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: passport,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      passport = value;
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
                const SizedBox(height: 4),
                Table(
                  border: TableBorder.all(color: kGreyColor),
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('昨日計'),
                        ),
                        FormValue(
                          passportCount1,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: passportCount1,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      passportCount1 = value;
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
                          child: Text('本日計'),
                        ),
                        FormValue(
                          passportCount2,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: passportCount2,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      passportCount2 = value;
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
                          child: Text('合計'),
                        ),
                        FormValue(
                          passportCount3,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(
                                      text: passportCount3,
                                    ),
                                    textInputType: TextInputType.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      passportCount3 = value;
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
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          widget.loginProvider.user?.president == true
              ? FloatingActionButton.extended(
                  heroTag: 'approval',
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => ApprovalReportDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      report: widget.report,
                    ),
                  ),
                  backgroundColor: kDeepOrangeColor,
                  icon: const Icon(
                    Icons.check,
                    color: kWhiteColor,
                  ),
                  label: const Text(
                    '承認する',
                    style: TextStyle(color: kWhiteColor),
                  ),
                )
              : Container(),
          const SizedBox(height: 8),
          FloatingActionButton.extended(
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
                visitCount1_12: visitCount1_12,
                visitCount1_20: visitCount1_20,
                visitCount1_22: visitCount1_22,
                visitCount2_12: visitCount2_12,
                visitCount2_20: visitCount2_20,
                visitCount2_22: visitCount2_22,
                visitCount3_12: visitCount3_12,
                visitCount3_20: visitCount3_20,
                visitCount3_22: visitCount3_22,
                visitCount4_12: visitCount4_12,
                visitCount4_20: visitCount4_20,
                visitCount4_22: visitCount4_22,
                visitCount5_12: visitCount5_12,
                visitCount5_20: visitCount5_20,
                visitCount5_22: visitCount5_22,
                visitCount6_12: visitCount6_12,
                visitCount6_20: visitCount6_20,
                visitCount6_22: visitCount6_22,
                lockerUse: lockerUse,
                lockerLost: lockerLost,
                lockerRecovery: lockerRecovery,
                event1: event1,
                event2: event2,
                marketing: marketing,
                interview: interview,
                openSquare: openSquare,
                openSquareFee: openSquareFee,
                openSquareStatus: openSquareStatus,
                meeting: meeting,
                mailCheck10Name: mailCheck10Name,
                mailCheck10Status: mailCheck10Status,
                mailCheck12Name: mailCheck12Name,
                mailCheck12Status: mailCheck12Status,
                mailCheck18Name: mailCheck18Name,
                mailCheck18Status: mailCheck18Status,
                mailCheck22Name: mailCheck22Name,
                mailCheck22Status: mailCheck22Status,
                warning19Status: warning19Status,
                warning19Deal: warning19Deal,
                warning23Status: warning23Status,
                warning23Deal: warning23Deal,
                advance1: advance1,
                advance2: advance2,
                advance3: advance3,
                repair: repair,
                repairStatus: repairStatus,
                repairDeal: repairDeal,
                problem: problem,
                problemDeal: problemDeal,
                pamphlet1Status: pamphlet1Status,
                pamphlet1Name: pamphlet1Name,
                pamphlet1Fee: pamphlet1Fee,
                pamphlet2Status: pamphlet2Status,
                pamphlet2Name: pamphlet2Name,
                pamphlet2Fee: pamphlet2Fee,
                pamphlet3Status: pamphlet3Status,
                pamphlet3Name: pamphlet3Name,
                pamphlet3Fee: pamphlet3Fee,
                pamphlet4Status: pamphlet4Status,
                pamphlet4Name: pamphlet4Name,
                pamphlet4Fee: pamphlet4Fee,
                pamphlet5Status: pamphlet5Status,
                pamphlet5Name: pamphlet5Name,
                pamphlet5Fee: pamphlet5Fee,
                pamphlet6Status: pamphlet6Status,
                pamphlet6Name: pamphlet6Name,
                pamphlet6Fee: pamphlet6Fee,
                pamphlet7Status: pamphlet7Status,
                pamphlet7Name: pamphlet7Name,
                pamphlet7Fee: pamphlet7Fee,
                equipment1Type: equipment1Type,
                equipment1Name: equipment1Name,
                equipment1Vendor: equipment1Vendor,
                equipment1Delivery: equipment1Delivery,
                equipment1Client: equipment1Client,
                equipment2Type: equipment2Type,
                equipment2Name: equipment2Name,
                equipment2Vendor: equipment2Vendor,
                equipment2Delivery: equipment2Delivery,
                equipment2Client: equipment2Client,
                equipment3Type: equipment3Type,
                equipment3Name: equipment3Name,
                equipment3Vendor: equipment3Vendor,
                equipment3Delivery: equipment3Delivery,
                equipment3Client: equipment3Client,
                equipment4Type: equipment4Type,
                equipment4Name: equipment4Name,
                equipment4Vendor: equipment4Vendor,
                equipment4Delivery: equipment4Delivery,
                equipment4Client: equipment4Client,
                equipment5Type: equipment5Type,
                equipment5Name: equipment5Name,
                equipment5Vendor: equipment5Vendor,
                equipment5Delivery: equipment5Delivery,
                equipment5Client: equipment5Client,
                equipment6Type: equipment6Type,
                equipment6Name: equipment6Name,
                equipment6Vendor: equipment6Vendor,
                equipment6Delivery: equipment6Delivery,
                equipment6Client: equipment6Client,
                contact: contact,
                lastConfirm: lastConfirm,
                agenda: agenda,
                confirm1: confirm1,
                confirm2: confirm2,
                confirm3: confirm3,
                confirm4: confirm4,
                confirm5: confirm5,
                confirm6: confirm6,
                confirm7: confirm7,
                confirm8: confirm8,
                confirm9: confirm9,
                confirm10: confirm10,
                confirm11: confirm11,
                confirm12: confirm12,
                passport: passport,
                passportCount1: passportCount1,
                passportCount2: passportCount2,
                passportCount3: passportCount3,
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
        ],
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

class ApprovalReportDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ReportModel report;

  const ApprovalReportDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.report,
    super.key,
  });

  @override
  State<ApprovalReportDialog> createState() => _ApprovalReportDialogState();
}

class _ApprovalReportDialogState extends State<ApprovalReportDialog> {
  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);
    return CustomAlertDialog(
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 8),
          Text(
            '本当に承認しますか？',
            style: TextStyle(color: kRedColor),
          ),
        ],
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
          label: '承認する',
          labelColor: kWhiteColor,
          backgroundColor: kDeepOrangeColor,
          onPressed: () async {
            String? error = await reportProvider.approval(
              report: widget.report,
              loginUser: widget.loginProvider.user,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '承認しました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
