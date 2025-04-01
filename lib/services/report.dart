import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/models/report.dart';
import 'package:miel_work_app/models/report_visitor.dart';

class ReportService {
  String collection = 'report';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String id() {
    return firestore.collection(collection).doc().id;
  }

  void create(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).set(values);
  }

  void update(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).update(values);
  }

  void delete(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).delete();
  }

  Future<ReportModel?> selectData({
    required String id,
  }) async {
    ReportModel? ret;
    await firestore
        .collection(collection)
        .where('id', isEqualTo: id)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = ReportModel.fromSnapshot(value.docs.first);
      }
    });
    return ret;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList({
    required String? organizationId,
    required DateTime? searchStart,
    required DateTime? searchEnd,
  }) {
    if (searchStart != null && searchEnd != null) {
      Timestamp startAt = convertTimestamp(searchStart, false);
      Timestamp endAt = convertTimestamp(searchEnd, true);
      return FirebaseFirestore.instance
          .collection(collection)
          .where('organizationId', isEqualTo: organizationId ?? 'error')
          .orderBy('createdAt', descending: false)
          .startAt([startAt]).endAt([endAt]).snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection(collection)
          .where('organizationId', isEqualTo: organizationId ?? 'error')
          .orderBy('createdAt', descending: true)
          .snapshots();
    }
  }

  List<ReportModel> generateList({
    required QuerySnapshot<Map<String, dynamic>>? data,
  }) {
    List<ReportModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ret.add(ReportModel.fromSnapshot(doc));
    }
    return ret;
  }

  Future<List<int>> getVisitorAll({
    required String? organizationId,
    required DateTime day,
  }) async {
    List<int> ret = [0, 0, 0];
    DateTime dayStart = DateTime(day.year, day.month, day.day);
    DateTime dayEnd = DateTime(
      day.year,
      day.month,
      day.day,
      23,
      59,
      59,
    );
    Timestamp startAt = convertTimestamp(dayStart, false);
    Timestamp endAt = convertTimestamp(dayEnd, true);
    await firestore
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId ?? 'error')
        .orderBy('createdAt', descending: false)
        .startAt([startAt])
        .endAt([endAt])
        .get()
        .then((value) {
          if (value.docs.isNotEmpty) {
            ReportModel report = ReportModel.fromSnapshot(value.docs.first);
            ReportVisitorModel reportVisitor = report.reportVisitor;
            int floor12 = reportVisitor.floor1_12 +
                reportVisitor.floor2_12 +
                reportVisitor.floor3_12 +
                reportVisitor.floor4_12 +
                reportVisitor.floor5_12;
            int floor20 = reportVisitor.floor1_20 +
                reportVisitor.floor2_20 +
                reportVisitor.floor3_20 +
                reportVisitor.floor4_20 +
                reportVisitor.floor5_20;
            int floor22 = reportVisitor.floor1_22 +
                reportVisitor.floor2_22 +
                reportVisitor.floor3_22 +
                reportVisitor.floor4_22 +
                reportVisitor.floor5_22;
            ret = [floor12, floor20, floor22];
          }
        });
    return ret;
  }
}
