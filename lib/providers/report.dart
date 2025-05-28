import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/models/organization.dart';
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
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/log.dart';
import 'package:miel_work_app/services/report.dart';

class ReportProvider with ChangeNotifier {
  final ReportService _reportService = ReportService();
  final LogService _logService = LogService();

  Future<String?> create({
    required OrganizationModel? organization,
    required DateTime createdAt,
    required List<ReportWorkerModel> reportWorkers,
    required List<ReportWorkerModel> reportWorkersGuardsman,
    required List<ReportWorkerModel> reportWorkersGarbageman,
    required ReportVisitorModel reportVisitor,
    required ReportLockerModel reportLocker,
    required List<ReportPlanModel> reportPlans,
    required ReportCheckModel reportCheck,
    required int advancePayment1,
    required int advancePayment2,
    required List<ReportRepairModel> reportRepairs,
    required List<ReportProblemModel> reportProblems,
    required List<ReportPamphletModel> reportPamphlets,
    required List<ReportEquipmentModel> reportEquipments,
    required String remarks,
    required String agenda,
    required bool lastConfirmShop,
    required DateTime lastConfirmShopAt,
    required String lastConfirmShopName,
    required bool lastConfirmCenter,
    required DateTime lastConfirmCenterAt,
    required bool lastConfirmExhaust,
    required DateTime lastConfirmExhaustAt,
    required bool lastConfirmRoof,
    required DateTime lastConfirmRoofAt,
    required bool lastConfirmAirCon,
    required DateTime lastConfirmAirConAt,
    required bool lastConfirmToilet,
    required DateTime lastConfirmToiletAt,
    required bool lastConfirmBaby,
    required DateTime lastConfirmBabyAt,
    required bool lastConfirmPC,
    required DateTime lastConfirmPCAt,
    required bool lastConfirmTel,
    required DateTime lastConfirmTelAt,
    required bool lastConfirmCoupon,
    required DateTime lastConfirmCouponAt,
    required String lastConfirmCouponNumber,
    required bool lastConfirmCalendar,
    required DateTime lastConfirmCalendarAt,
    required bool lastConfirmMoney,
    required DateTime lastConfirmMoneyAt,
    required bool lastConfirmLock,
    required DateTime lastConfirmLockAt,
    required String lastConfirmLockName,
    required bool lastConfirmUser,
    required DateTime lastConfirmUserAt,
    required String lastConfirmUserName,
    required bool lastExitUser,
    required DateTime lastExitUserAt,
    required String lastExitUserName,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '日報の保存に失敗しました';
    if (loginUser == null) return '日報の保存に失敗しました';
    try {
      String id = _reportService.id();
      List<Map> reportWorkersMap = [];
      for (final data in reportWorkers) {
        reportWorkersMap.add(data.toMap());
      }
      List<Map> reportWorkersGuardsmanMap = [];
      for (final data in reportWorkersGuardsman) {
        reportWorkersGuardsmanMap.add(data.toMap());
      }
      List<Map> reportWorkersGarbagemanMap = [];
      for (final data in reportWorkersGarbageman) {
        reportWorkersGarbagemanMap.add(data.toMap());
      }
      List<Map> reportPlansMap = [];
      for (final data in reportPlans) {
        reportPlansMap.add(data.toMap());
      }
      List<Map> reportRepairsMap = [];
      for (final data in reportRepairs) {
        reportRepairsMap.add(data.toMap());
      }
      List<Map> reportProblemsMap = [];
      for (final data in reportProblems) {
        reportProblemsMap.add(data.toMap());
      }
      List<Map> reportPamphletsMap = [];
      for (final data in reportPamphlets) {
        reportPamphletsMap.add(data.toMap());
      }
      List<Map> reportEquipmentsMap = [];
      for (final data in reportEquipments) {
        reportEquipmentsMap.add(data.toMap());
      }
      _reportService.create({
        'id': id,
        'organizationId': organization.id,
        'reportWorkers': reportWorkersMap,
        'reportWorkersGuardsman': reportWorkersGuardsmanMap,
        'reportWorkersGarbageman': reportWorkersGarbagemanMap,
        'reportVisitor': reportVisitor.toMap(),
        'reportLocker': reportLocker.toMap(),
        'reportPlans': reportPlansMap,
        'reportCheck': reportCheck.toMap(),
        'advancePayment1': advancePayment1,
        'advancePayment2': advancePayment2,
        'reportRepairs': reportRepairsMap,
        'reportProblems': reportProblemsMap,
        'reportPamphlets': reportPamphletsMap,
        'reportEquipments': reportEquipmentsMap,
        'remarks': remarks,
        'agenda': agenda,
        'lastConfirmShop': lastConfirmShop,
        'lastConfirmShopAt': lastConfirmShopAt,
        'lastConfirmShopName': lastConfirmShopName,
        'lastConfirmCenter': lastConfirmCenter,
        'lastConfirmCenterAt': lastConfirmCenterAt,
        'lastConfirmExhaust': lastConfirmExhaust,
        'lastConfirmExhaustAt': lastConfirmExhaustAt,
        'lastConfirmRoof': lastConfirmRoof,
        'lastConfirmRoofAt': lastConfirmRoofAt,
        'lastConfirmAirCon': lastConfirmAirCon,
        'lastConfirmAirConAt': lastConfirmAirConAt,
        'lastConfirmToilet': lastConfirmToilet,
        'lastConfirmToiletAt': lastConfirmToiletAt,
        'lastConfirmBaby': lastConfirmBaby,
        'lastConfirmBabyAt': lastConfirmBabyAt,
        'lastConfirmPC': lastConfirmPC,
        'lastConfirmPCAt': lastConfirmPCAt,
        'lastConfirmTel': lastConfirmTel,
        'lastConfirmTelAt': lastConfirmTelAt,
        'lastConfirmCoupon': lastConfirmCoupon,
        'lastConfirmCouponAt': lastConfirmCouponAt,
        'lastConfirmCouponNumber': lastConfirmCouponNumber,
        'lastConfirmCalendar': lastConfirmCalendar,
        'lastConfirmCalendarAt': lastConfirmCalendarAt,
        'lastConfirmMoney': lastConfirmMoney,
        'lastConfirmMoneyAt': lastConfirmMoneyAt,
        'lastConfirmLock': lastConfirmLock,
        'lastConfirmLockAt': lastConfirmLockAt,
        'lastConfirmLockName': lastConfirmLockName,
        'lastConfirmUser': lastConfirmUser,
        'lastConfirmUserAt': lastConfirmUserAt,
        'lastConfirmUserName': lastConfirmUserName,
        'lastExitUser': lastExitUser,
        'lastExitUserAt': lastExitUserAt,
        'lastExitUserName': lastExitUserName,
        'approval': 0,
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': createdAt,
        'expirationAt': createdAt.add(const Duration(days: 365)),
      });
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': organization.id,
        'content': '業務日報(${dateText('MM月dd日(E)', createdAt)})を保存しました。',
        'device': 'SP(アプリ)',
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '日報の保存に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required ReportModel report,
    required List<ReportWorkerModel> reportWorkers,
    required List<ReportWorkerModel> reportWorkersGuardsman,
    required List<ReportWorkerModel> reportWorkersGarbageman,
    required ReportVisitorModel reportVisitor,
    required ReportLockerModel reportLocker,
    required List<ReportPlanModel> reportPlans,
    required ReportCheckModel reportCheck,
    required int advancePayment1,
    required int advancePayment2,
    required List<ReportRepairModel> reportRepairs,
    required List<ReportProblemModel> reportProblems,
    required List<ReportPamphletModel> reportPamphlets,
    required List<ReportEquipmentModel> reportEquipments,
    required String remarks,
    required String agenda,
    required bool lastConfirmShop,
    required DateTime lastConfirmShopAt,
    required String lastConfirmShopName,
    required bool lastConfirmCenter,
    required DateTime lastConfirmCenterAt,
    required bool lastConfirmExhaust,
    required DateTime lastConfirmExhaustAt,
    required bool lastConfirmRoof,
    required DateTime lastConfirmRoofAt,
    required bool lastConfirmAirCon,
    required DateTime lastConfirmAirConAt,
    required bool lastConfirmToilet,
    required DateTime lastConfirmToiletAt,
    required bool lastConfirmBaby,
    required DateTime lastConfirmBabyAt,
    required bool lastConfirmPC,
    required DateTime lastConfirmPCAt,
    required bool lastConfirmTel,
    required DateTime lastConfirmTelAt,
    required bool lastConfirmCoupon,
    required DateTime lastConfirmCouponAt,
    required String lastConfirmCouponNumber,
    required bool lastConfirmCalendar,
    required DateTime lastConfirmCalendarAt,
    required bool lastConfirmMoney,
    required DateTime lastConfirmMoneyAt,
    required bool lastConfirmLock,
    required DateTime lastConfirmLockAt,
    required String lastConfirmLockName,
    required bool lastConfirmUser,
    required DateTime lastConfirmUserAt,
    required String lastConfirmUserName,
    required bool lastExitUser,
    required DateTime lastExitUserAt,
    required String lastExitUserName,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '日報の保存に失敗しました';
    try {
      List<Map> reportWorkersMap = [];
      for (final data in reportWorkers) {
        reportWorkersMap.add(data.toMap());
      }
      List<Map> reportWorkersGuardsmanMap = [];
      for (final data in reportWorkersGuardsman) {
        reportWorkersGuardsmanMap.add(data.toMap());
      }
      List<Map> reportWorkersGarbagemanMap = [];
      for (final data in reportWorkersGarbageman) {
        reportWorkersGarbagemanMap.add(data.toMap());
      }
      List<Map> reportPlansMap = [];
      for (final data in reportPlans) {
        reportPlansMap.add(data.toMap());
      }
      List<Map> reportRepairsMap = [];
      for (final data in reportRepairs) {
        reportRepairsMap.add(data.toMap());
      }
      List<Map> reportProblemsMap = [];
      for (final data in reportProblems) {
        reportProblemsMap.add(data.toMap());
      }
      List<Map> reportPamphletsMap = [];
      for (final data in reportPamphlets) {
        reportPamphletsMap.add(data.toMap());
      }
      List<Map> reportEquipmentsMap = [];
      for (final data in reportEquipments) {
        reportEquipmentsMap.add(data.toMap());
      }
      _reportService.update({
        'id': report.id,
        'reportWorkers': reportWorkersMap,
        'reportWorkersGuardsman': reportWorkersGuardsmanMap,
        'reportWorkersGarbageman': reportWorkersGarbagemanMap,
        'reportVisitor': reportVisitor.toMap(),
        'reportLocker': reportLocker.toMap(),
        'reportPlans': reportPlansMap,
        'reportCheck': reportCheck.toMap(),
        'advancePayment1': advancePayment1,
        'advancePayment2': advancePayment2,
        'reportRepairs': reportRepairsMap,
        'reportProblems': reportProblemsMap,
        'reportPamphlets': reportPamphletsMap,
        'reportEquipments': reportEquipmentsMap,
        'remarks': remarks,
        'agenda': agenda,
        'lastConfirmShop': lastConfirmShop,
        'lastConfirmShopAt': lastConfirmShopAt,
        'lastConfirmShopName': lastConfirmShopName,
        'lastConfirmCenter': lastConfirmCenter,
        'lastConfirmCenterAt': lastConfirmCenterAt,
        'lastConfirmExhaust': lastConfirmExhaust,
        'lastConfirmExhaustAt': lastConfirmExhaustAt,
        'lastConfirmRoof': lastConfirmRoof,
        'lastConfirmRoofAt': lastConfirmRoofAt,
        'lastConfirmAirCon': lastConfirmAirCon,
        'lastConfirmAirConAt': lastConfirmAirConAt,
        'lastConfirmToilet': lastConfirmToilet,
        'lastConfirmToiletAt': lastConfirmToiletAt,
        'lastConfirmBaby': lastConfirmBaby,
        'lastConfirmBabyAt': lastConfirmBabyAt,
        'lastConfirmPC': lastConfirmPC,
        'lastConfirmPCAt': lastConfirmPCAt,
        'lastConfirmTel': lastConfirmTel,
        'lastConfirmTelAt': lastConfirmTelAt,
        'lastConfirmCoupon': lastConfirmCoupon,
        'lastConfirmCouponAt': lastConfirmCouponAt,
        'lastConfirmCouponNumber': lastConfirmCouponNumber,
        'lastConfirmCalendar': lastConfirmCalendar,
        'lastConfirmCalendarAt': lastConfirmCalendarAt,
        'lastConfirmMoney': lastConfirmMoney,
        'lastConfirmMoneyAt': lastConfirmMoneyAt,
        'lastConfirmLock': lastConfirmLock,
        'lastConfirmLockAt': lastConfirmLockAt,
        'lastConfirmLockName': lastConfirmLockName,
        'lastConfirmUser': lastConfirmUser,
        'lastConfirmUserAt': lastConfirmUserAt,
        'lastConfirmUserName': lastConfirmUserName,
        'lastExitUser': lastExitUser,
        'lastExitUserAt': lastExitUserAt,
        'lastExitUserName': lastExitUserName,
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
      });
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': report.organizationId,
        'content': '業務日報(${dateText('MM月dd日(E)', report.createdAt)})を保存しました。',
        'device': 'SP(アプリ)',
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '日報の保存に失敗しました';
    }
    return error;
  }

  Future<String?> addComment({
    required OrganizationModel? organization,
    required ReportModel report,
    required String content,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '社内コメントの追記に失敗しました';
    if (content == '') return '社内コメントの追記に失敗しました';
    if (loginUser == null) return '社内コメントの追記に失敗しました';
    try {
      List<Map> comments = [];
      if (report.comments.isNotEmpty) {
        for (final comment in report.comments) {
          comments.add(comment.toMap());
        }
      }
      comments.add({
        'id': dateText('yyyyMMddHHmm', DateTime.now()),
        'userId': loginUser.id,
        'userName': loginUser.name,
        'content': content,
        'readUserIds': [loginUser.id],
        'createdAt': DateTime.now(),
      });
      _reportService.update({
        'id': report.id,
        'comments': comments,
      });
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': organization.id,
        'content':
            '業務日報(${dateText('MM月dd日(E)', report.createdAt)})に社内コメントを追記しました。',
        'device': 'SP(アプリ)',
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '社内コメントの追記に失敗しました';
    }
    return error;
  }

  Future<String?> approval({
    required ReportModel report,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '日報の承認に失敗しました';
    try {
      _reportService.update({
        'id': report.id,
        'approval': 1,
      });
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': report.organizationId,
        'content': '業務日報(${dateText('MM月dd日(E)', report.createdAt)})を承認しました。',
        'device': 'SP(アプリ)',
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '日報の承認に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required ReportModel report,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '日報の削除に失敗しました';
    try {
      _reportService.delete({
        'id': report.id,
      });
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': report.organizationId,
        'content': '業務日報(${dateText('MM月dd日(E)', report.createdAt)})を削除しました。',
        'device': 'SP(アプリ)',
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '日報の削除に失敗しました';
    }
    return error;
  }
}
