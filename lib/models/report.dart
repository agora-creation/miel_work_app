import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/comment.dart';
import 'package:miel_work_app/models/report_check.dart';
import 'package:miel_work_app/models/report_equipment.dart';
import 'package:miel_work_app/models/report_locker.dart';
import 'package:miel_work_app/models/report_pamphlet.dart';
import 'package:miel_work_app/models/report_plan.dart';
import 'package:miel_work_app/models/report_problem.dart';
import 'package:miel_work_app/models/report_repair.dart';
import 'package:miel_work_app/models/report_visitor.dart';
import 'package:miel_work_app/models/report_worker.dart';

class ReportModel {
  String _id = '';
  String _organizationId = '';
  List<ReportWorkerModel> reportWorkers = [];
  List<ReportWorkerModel> reportWorkersGuardsman = [];
  List<ReportWorkerModel> reportWorkersGarbageman = [];
  ReportVisitorModel reportVisitor = ReportVisitorModel.fromMap({});
  ReportLockerModel reportLocker = ReportLockerModel.fromMap({});
  List<ReportPlanModel> reportPlans = [];
  ReportCheckModel reportCheck = ReportCheckModel.fromMap({});
  int _advancePayment1 = 0;
  int _advancePayment2 = 0;
  List<ReportRepairModel> reportRepairs = [];
  List<ReportProblemModel> reportProblems = [];
  List<ReportPamphletModel> reportPamphlets = [];
  List<ReportEquipmentModel> reportEquipments = [];
  String _remarks = '';
  String _agenda = '';
  bool _lastConfirmShop = false;
  DateTime _lastConfirmShopAt = DateTime.now();
  String _lastConfirmShopName = '';
  bool _lastConfirmCenter = false;
  DateTime _lastConfirmCenterAt = DateTime.now();
  bool _lastConfirmExhaust = false;
  DateTime _lastConfirmExhaustAt = DateTime.now();
  bool _lastConfirmRoof = false;
  DateTime _lastConfirmRoofAt = DateTime.now();
  bool _lastConfirmAirCon = false;
  DateTime _lastConfirmAirConAt = DateTime.now();
  bool _lastConfirmToilet = false;
  DateTime _lastConfirmToiletAt = DateTime.now();
  bool _lastConfirmBaby = false;
  DateTime _lastConfirmBabyAt = DateTime.now();
  bool _lastConfirmPC = false;
  DateTime _lastConfirmPCAt = DateTime.now();
  bool _lastConfirmTel = false;
  DateTime _lastConfirmTelAt = DateTime.now();
  bool _lastConfirmCoupon = false;
  DateTime _lastConfirmCouponAt = DateTime.now();
  String _lastConfirmCouponNumber = '';
  bool _lastConfirmCalendar = false;
  DateTime _lastConfirmCalendarAt = DateTime.now();
  bool _lastConfirmMoney = false;
  DateTime _lastConfirmMoneyAt = DateTime.now();
  bool _lastConfirmLock = false;
  DateTime _lastConfirmLockAt = DateTime.now();
  String _lastConfirmLockName = '';
  bool _lastConfirmUser = false;
  DateTime _lastConfirmUserAt = DateTime.now();
  String _lastConfirmUserName = '';
  bool _lastExitUser = false;
  DateTime _lastExitUserAt = DateTime.now();
  String _lastExitUserName = '';
  List<CommentModel> comments = [];
  int _approval = 0;
  String _createdUserId = '';
  String _createdUserName = '';
  DateTime _createdAt = DateTime.now();
  DateTime _expirationAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  int get advancePayment1 => _advancePayment1;
  int get advancePayment2 => _advancePayment2;
  String get remarks => _remarks;
  String get agenda => _agenda;
  bool get lastConfirmShop => _lastConfirmShop;
  DateTime get lastConfirmShopAt => _lastConfirmShopAt;
  String get lastConfirmShopName => _lastConfirmShopName;
  bool get lastConfirmCenter => _lastConfirmCenter;
  DateTime get lastConfirmCenterAt => _lastConfirmCenterAt;
  bool get lastConfirmExhaust => _lastConfirmExhaust;
  DateTime get lastConfirmExhaustAt => _lastConfirmExhaustAt;
  bool get lastConfirmRoof => _lastConfirmRoof;
  DateTime get lastConfirmRoofAt => _lastConfirmRoofAt;
  bool get lastConfirmAirCon => _lastConfirmAirCon;
  DateTime get lastConfirmAirConAt => _lastConfirmAirConAt;
  bool get lastConfirmToilet => _lastConfirmToilet;
  DateTime get lastConfirmToiletAt => _lastConfirmToiletAt;
  bool get lastConfirmBaby => _lastConfirmBaby;
  DateTime get lastConfirmBabyAt => _lastConfirmBabyAt;
  bool get lastConfirmPC => _lastConfirmPC;
  DateTime get lastConfirmPCAt => _lastConfirmPCAt;
  bool get lastConfirmTel => _lastConfirmTel;
  DateTime get lastConfirmTelAt => _lastConfirmTelAt;
  bool get lastConfirmCoupon => _lastConfirmCoupon;
  DateTime get lastConfirmCouponAt => _lastConfirmCouponAt;
  String get lastConfirmCouponNumber => _lastConfirmCouponNumber;
  bool get lastConfirmCalendar => _lastConfirmCalendar;
  DateTime get lastConfirmCalendarAt => _lastConfirmCalendarAt;
  bool get lastConfirmMoney => _lastConfirmMoney;
  DateTime get lastConfirmMoneyAt => _lastConfirmMoneyAt;
  bool get lastConfirmLock => _lastConfirmLock;
  DateTime get lastConfirmLockAt => _lastConfirmLockAt;
  String get lastConfirmLockName => _lastConfirmLockName;
  bool get lastConfirmUser => _lastConfirmUser;
  DateTime get lastConfirmUserAt => _lastConfirmUserAt;
  String get lastConfirmUserName => _lastConfirmUserName;
  bool get lastExitUser => _lastExitUser;
  DateTime get lastExitUserAt => _lastExitUserAt;
  String get lastExitUserName => _lastExitUserName;
  int get approval => _approval;
  String get createdUserId => _createdUserId;
  String get createdUserName => _createdUserName;
  DateTime get createdAt => _createdAt;
  DateTime get expirationAt => _expirationAt;

  ReportModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    reportWorkers = _convertReportWorkers(data['reportWorkers'] ?? []);
    reportWorkersGuardsman =
        _convertReportWorkers(data['reportWorkersGuardsman'] ?? []);
    reportWorkersGarbageman =
        _convertReportWorkers(data['reportWorkersGarbageman'] ?? []);
    reportVisitor = ReportVisitorModel.fromMap(data['reportVisitor']);
    reportLocker = ReportLockerModel.fromMap(data['reportLocker']);
    reportPlans = _convertReportPlans(data['reportPlans'] ?? []);
    reportCheck = ReportCheckModel.fromMap(data['reportCheck']);
    _advancePayment1 = data['advancePayment1'] ?? 0;
    _advancePayment2 = data['advancePayment2'] ?? 0;
    reportRepairs = _convertReportRepairs(data['reportRepairs'] ?? []);
    reportProblems = _convertReportProblems(data['reportProblems'] ?? []);
    reportPamphlets = _convertReportPamphlets(data['reportPamphlets'] ?? []);
    reportEquipments = _convertReportEquipments(data['reportEquipments'] ?? []);
    _remarks = data['remarks'] ?? '';
    _agenda = data['agenda'] ?? '';
    _lastConfirmShop = data['lastConfirmShop'] ?? false;
    _lastConfirmShopAt = data['lastConfirmShopAt'].toDate() ?? DateTime.now();
    _lastConfirmShopName = data['lastConfirmShopName'] ?? '';
    _lastConfirmCenter = data['lastConfirmCenter'] ?? false;
    _lastConfirmCenterAt =
        data['lastConfirmCenterAt'].toDate() ?? DateTime.now();
    _lastConfirmExhaust = data['lastConfirmExhaust'] ?? false;
    _lastConfirmExhaustAt =
        data['lastConfirmExhaustAt'].toDate() ?? DateTime.now();
    _lastConfirmRoof = data['lastConfirmRoof'] ?? false;
    _lastConfirmRoofAt = data['lastConfirmRoofAt'].toDate() ?? DateTime.now();
    _lastConfirmAirCon = data['lastConfirmAirCon'] ?? false;
    _lastConfirmAirConAt =
        data['lastConfirmAirConAt'].toDate() ?? DateTime.now();
    _lastConfirmToilet = data['lastConfirmToilet'] ?? false;
    _lastConfirmToiletAt =
        data['lastConfirmToiletAt'].toDate() ?? DateTime.now();
    _lastConfirmBaby = data['lastConfirmBaby'] ?? false;
    _lastConfirmBabyAt = data['lastConfirmBabyAt'].toDate() ?? DateTime.now();
    _lastConfirmPC = data['lastConfirmPC'] ?? false;
    _lastConfirmPCAt = data['lastConfirmPCAt'].toDate() ?? DateTime.now();
    _lastConfirmTel = data['lastConfirmTel'] ?? false;
    _lastConfirmTelAt = data['lastConfirmTelAt'].toDate() ?? DateTime.now();
    _lastConfirmCoupon = data['lastConfirmCoupon'] ?? false;
    _lastConfirmCouponAt =
        data['lastConfirmCouponAt'].toDate() ?? DateTime.now();
    _lastConfirmCouponNumber = data['lastConfirmCouponNumber'] ?? '';
    _lastConfirmCalendar = data['lastConfirmCalendar'] ?? false;
    _lastConfirmCalendarAt =
        data['lastConfirmCalendarAt'].toDate() ?? DateTime.now();
    _lastConfirmMoney = data['lastConfirmMoney'] ?? false;
    _lastConfirmMoneyAt = data['lastConfirmMoneyAt'].toDate() ?? DateTime.now();
    _lastConfirmLock = data['lastConfirmLock'] ?? false;
    _lastConfirmLockAt = data['lastConfirmLockAt'].toDate() ?? DateTime.now();
    _lastConfirmLockName = data['lastConfirmLockName'] ?? '';
    _lastConfirmUser = data['lastConfirmUser'] ?? false;
    _lastConfirmUserAt = data['lastConfirmUserAt'].toDate() ?? DateTime.now();
    _lastConfirmUserName = data['lastConfirmUserName'] ?? '';
    _lastExitUser = data['lastExitUser'] ?? false;
    if (data['lastExitUserAt'] != null) {
      _lastExitUserAt = data['lastExitUserAt'].toDate() ?? DateTime.now();
    }
    _lastExitUserName = data['lastExitUserName'] ?? '';
    comments = _convertComments(data['comments'] ?? []);
    _approval = data['approval'] ?? 0;
    _createdUserId = data['createdUserId'] ?? '';
    _createdUserName = data['createdUserName'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
    _expirationAt = data['expirationAt'].toDate() ?? DateTime.now();
  }

  List<ReportWorkerModel> _convertReportWorkers(List list) {
    List<ReportWorkerModel> converted = [];
    for (Map data in list) {
      converted.add(ReportWorkerModel.fromMap(data));
    }
    return converted;
  }

  List<ReportPlanModel> _convertReportPlans(List list) {
    List<ReportPlanModel> converted = [];
    for (Map data in list) {
      converted.add(ReportPlanModel.fromMap(data));
    }
    return converted;
  }

  List<ReportRepairModel> _convertReportRepairs(List list) {
    List<ReportRepairModel> converted = [];
    for (Map data in list) {
      converted.add(ReportRepairModel.fromMap(data));
    }
    return converted;
  }

  List<ReportProblemModel> _convertReportProblems(List list) {
    List<ReportProblemModel> converted = [];
    for (Map data in list) {
      converted.add(ReportProblemModel.fromMap(data));
    }
    return converted;
  }

  List<ReportPamphletModel> _convertReportPamphlets(List list) {
    List<ReportPamphletModel> converted = [];
    for (Map data in list) {
      converted.add(ReportPamphletModel.fromMap(data));
    }
    return converted;
  }

  List<ReportEquipmentModel> _convertReportEquipments(List list) {
    List<ReportEquipmentModel> converted = [];
    for (Map data in list) {
      converted.add(ReportEquipmentModel.fromMap(data));
    }
    return converted;
  }

  String approvalText() {
    switch (_approval) {
      case 0:
        return '承認待ち';
      case 1:
        return '承認済み';
      default:
        return '承認待ち';
    }
  }

  List<CommentModel> _convertComments(List list) {
    List<CommentModel> converted = [];
    for (Map data in list) {
      converted.add(CommentModel.fromMap(data));
    }
    return converted;
  }
}
