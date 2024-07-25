import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
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
import 'package:miel_work_app/services/plan.dart';
import 'package:miel_work_app/services/problem.dart';
import 'package:provider/provider.dart';

class ReportAddScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final DateTime day;

  const ReportAddScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.day,
    super.key,
  });

  @override
  State<ReportAddScreen> createState() => _ReportAddScreenState();
}

class _ReportAddScreenState extends State<ReportAddScreen> {
  PlanService planService = PlanService();
  ProblemService problemService = ProblemService();
  DateTime createdAt = DateTime.now();
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

  void _init() async {
    createdAt = widget.day;
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
          '${dateText('MM月dd日(E)', widget.day)}の日報',
          style: const TextStyle(color: kBlackColor),
        ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          String? error = await reportProvider.create(
            organization: widget.loginProvider.organization,
            createdAt: createdAt,
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
    );
  }
}
