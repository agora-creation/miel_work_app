import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/report.dart';
import 'package:miel_work_app/models/report_check.dart';
import 'package:miel_work_app/models/report_equipment.dart';
import 'package:miel_work_app/models/report_locker.dart';
import 'package:miel_work_app/models/report_pamphlet.dart';
import 'package:miel_work_app/models/report_plan.dart';
import 'package:miel_work_app/models/report_problem.dart';
import 'package:miel_work_app/models/report_repair.dart';
import 'package:miel_work_app/models/report_visitor.dart';
import 'package:miel_work_app/models/report_worker.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/report.dart';
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
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
  List<ReportWorkerModel> reportWorkers = [];
  ReportVisitorModel reportVisitor = ReportVisitorModel.fromMap({});
  ReportLockerModel reportLocker = ReportLockerModel.fromMap({});
  List<ReportPlanModel> reportPlans = [];
  ReportCheckModel reportCheck = ReportCheckModel.fromMap({});
  int advancePayment1 = 0;
  int advancePayment2 = 0;
  List<ReportRepairModel> reportRepairs = [];
  List<ReportProblemModel> reportProblems = [];
  List<ReportPamphletModel> reportPamphlets = [];
  List<ReportEquipmentModel> reportEquipments = [];
  String passport = '';
  int passportCount = 0;
  String remarks = '';
  String agenda = '';
  bool lastConfirmShop = false;
  DateTime lastConfirmShopAt = DateTime.now();
  String lastConfirmShopName = '';
  bool lastConfirmCenter = false;
  DateTime lastConfirmCenterAt = DateTime.now();
  bool lastConfirmExhaust = false;
  DateTime lastConfirmExhaustAt = DateTime.now();
  bool lastConfirmRoof = false;
  DateTime lastConfirmRoofAt = DateTime.now();
  bool lastConfirmAirCon = false;
  DateTime lastConfirmAirConAt = DateTime.now();
  bool lastConfirmToilet = false;
  DateTime lastConfirmToiletAt = DateTime.now();
  bool lastConfirmBaby = false;
  DateTime lastConfirmBabyAt = DateTime.now();
  bool lastConfirmPC = false;
  DateTime lastConfirmPCAt = DateTime.now();
  bool lastConfirmTel = false;
  DateTime lastConfirmTelAt = DateTime.now();
  bool lastConfirmCoupon = false;
  DateTime lastConfirmCouponAt = DateTime.now();
  bool lastConfirmCalendar = false;
  DateTime lastConfirmCalendarAt = DateTime.now();
  bool lastConfirmMoney = false;
  DateTime lastConfirmMoneyAt = DateTime.now();
  bool lastConfirmLock = false;
  DateTime lastConfirmLockAt = DateTime.now();
  bool lastConfirmUser = false;
  DateTime lastConfirmUserAt = DateTime.now();
  String lastConfirmUserName = '';

  void _init() {
    reportWorkers = widget.report.reportWorkers;
    reportVisitor = widget.report.reportVisitor;
    reportLocker = widget.report.reportLocker;
    reportPlans = widget.report.reportPlans;
    reportCheck = widget.report.reportCheck;
    advancePayment1 = widget.report.advancePayment1;
    advancePayment2 = widget.report.advancePayment2;
    reportRepairs = widget.report.reportRepairs;
    reportProblems = widget.report.reportProblems;
    reportPamphlets = widget.report.reportPamphlets;
    reportEquipments = widget.report.reportEquipments;
    passport = widget.report.passport;
    passportCount = widget.report.passportCount;
    remarks = widget.report.remarks;
    agenda = widget.report.agenda;
    lastConfirmShop = widget.report.lastConfirmShop;
    lastConfirmShopAt = widget.report.lastConfirmShopAt;
    lastConfirmShopName = widget.report.lastConfirmShopName;
    lastConfirmCenter = widget.report.lastConfirmCenter;
    lastConfirmCenterAt = widget.report.lastConfirmCenterAt;
    lastConfirmExhaust = widget.report.lastConfirmExhaust;
    lastConfirmExhaustAt = widget.report.lastConfirmExhaustAt;
    lastConfirmRoof = widget.report.lastConfirmRoof;
    lastConfirmRoofAt = widget.report.lastConfirmRoofAt;
    lastConfirmAirCon = widget.report.lastConfirmAirCon;
    lastConfirmAirConAt = widget.report.lastConfirmAirConAt;
    lastConfirmToilet = widget.report.lastConfirmToilet;
    lastConfirmToiletAt = widget.report.lastConfirmToiletAt;
    lastConfirmBaby = widget.report.lastConfirmBaby;
    lastConfirmBabyAt = widget.report.lastConfirmBabyAt;
    lastConfirmPC = widget.report.lastConfirmPC;
    lastConfirmPCAt = widget.report.lastConfirmPCAt;
    lastConfirmTel = widget.report.lastConfirmTel;
    lastConfirmTelAt = widget.report.lastConfirmTelAt;
    lastConfirmCoupon = widget.report.lastConfirmCoupon;
    lastConfirmCouponAt = widget.report.lastConfirmCouponAt;
    lastConfirmCalendar = widget.report.lastConfirmCalendar;
    lastConfirmCalendarAt = widget.report.lastConfirmCalendarAt;
    lastConfirmMoney = widget.report.lastConfirmMoney;
    lastConfirmMoneyAt = widget.report.lastConfirmMoneyAt;
    lastConfirmLock = widget.report.lastConfirmLock;
    lastConfirmLockAt = widget.report.lastConfirmLockAt;
    lastConfirmUser = widget.report.lastConfirmUser;
    lastConfirmUserAt = widget.report.lastConfirmUserAt;
    lastConfirmUserName = widget.report.lastConfirmUserName;
    setState(() {});
  }

  @override
  void initState() {
    _init();
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
                reportWorkers: reportWorkers,
                reportVisitor: reportVisitor,
                reportLocker: reportLocker,
                reportPlans: reportPlans,
                reportCheck: reportCheck,
                advancePayment1: advancePayment1,
                advancePayment2: advancePayment2,
                reportRepairs: reportRepairs,
                reportProblems: reportProblems,
                reportPamphlets: reportPamphlets,
                reportEquipments: reportEquipments,
                passport: passport,
                passportCount: passportCount,
                remarks: remarks,
                agenda: agenda,
                lastConfirmShop: lastConfirmShop,
                lastConfirmShopAt: lastConfirmShopAt,
                lastConfirmShopName: lastConfirmShopName,
                lastConfirmCenter: lastConfirmCenter,
                lastConfirmCenterAt: lastConfirmCenterAt,
                lastConfirmExhaust: lastConfirmExhaust,
                lastConfirmExhaustAt: lastConfirmExhaustAt,
                lastConfirmRoof: lastConfirmRoof,
                lastConfirmRoofAt: lastConfirmRoofAt,
                lastConfirmAirCon: lastConfirmAirCon,
                lastConfirmAirConAt: lastConfirmAirConAt,
                lastConfirmToilet: lastConfirmToilet,
                lastConfirmToiletAt: lastConfirmToiletAt,
                lastConfirmBaby: lastConfirmBaby,
                lastConfirmBabyAt: lastConfirmBabyAt,
                lastConfirmPC: lastConfirmPC,
                lastConfirmPCAt: lastConfirmPCAt,
                lastConfirmTel: lastConfirmTel,
                lastConfirmTelAt: lastConfirmTelAt,
                lastConfirmCoupon: lastConfirmCoupon,
                lastConfirmCouponAt: lastConfirmCouponAt,
                lastConfirmCalendar: lastConfirmCalendar,
                lastConfirmCalendarAt: lastConfirmCalendarAt,
                lastConfirmMoney: lastConfirmMoney,
                lastConfirmMoneyAt: lastConfirmMoneyAt,
                lastConfirmLock: lastConfirmLock,
                lastConfirmLockAt: lastConfirmLockAt,
                lastConfirmUser: lastConfirmUser,
                lastConfirmUserAt: lastConfirmUserAt,
                lastConfirmUserName: lastConfirmUserName,
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
