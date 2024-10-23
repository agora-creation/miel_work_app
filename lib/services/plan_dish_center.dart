import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/models/plan_dish_center.dart';

class PlanDishCenterService {
  String collection = 'planDishCenter';
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
    required DateTime? searchStart,
    required DateTime? searchEnd,
  }) {
    if (searchStart != null && searchEnd != null) {
      Timestamp startAt = convertTimestamp(searchStart, false);
      Timestamp endAt = convertTimestamp(searchEnd, true);
      return FirebaseFirestore.instance
          .collection(collection)
          .where('organizationId', isEqualTo: organizationId ?? 'error')
          .orderBy('startedAt', descending: false)
          .startAt([startAt]).endAt([endAt]).snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection(collection)
          .where('organizationId', isEqualTo: organizationId ?? 'error')
          .orderBy('startedAt', descending: false)
          .snapshots();
    }
  }

  List<PlanDishCenterModel> generateList({
    required QuerySnapshot<Map<String, dynamic>>? data,
  }) {
    List<PlanDishCenterModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ret.add(PlanDishCenterModel.fromSnapshot(doc));
    }
    return ret;
  }
}
