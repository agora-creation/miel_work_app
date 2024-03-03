import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/plan_shift.dart';

class PlanShiftService {
  String collection = 'planShift';
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

  Future<PlanShiftModel?> selectData({
    required String id,
  }) async {
    PlanShiftModel? ret;
    await firestore
        .collection(collection)
        .where('id', isEqualTo: id)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = PlanShiftModel.fromSnapshot(value.docs.first);
      }
    });
    return ret;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList({
    required String? organizationId,
  }) {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId ?? 'error')
        .orderBy('startedAt', descending: true)
        .snapshots();
  }
}
