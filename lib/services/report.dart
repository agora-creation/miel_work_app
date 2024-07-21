import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/models/report.dart';

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

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList({
    required String? organizationId,
    required DateTime searchMonth,
  }) {
    DateTime monthS = DateTime(searchMonth.year, searchMonth.month, 1);
    DateTime monthE = DateTime(searchMonth.year, searchMonth.month + 1, 1).add(
      const Duration(days: -1),
    );
    Timestamp startAt = convertTimestamp(monthS, false);
    Timestamp endAt = convertTimestamp(monthE, true);
    return FirebaseFirestore.instance
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId ?? 'error')
        .orderBy('createdAt', descending: false)
        .startAt([startAt]).endAt([endAt]).snapshots();
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
}
