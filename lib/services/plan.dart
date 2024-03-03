import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/plan.dart';

class PlanService {
  String collection = 'plan';
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

  Future<PlanModel?> selectData({
    required String id,
  }) async {
    PlanModel? ret;
    await firestore
        .collection(collection)
        .where('id', isEqualTo: id)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = PlanModel.fromSnapshot(value.docs.first);
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
