import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/request_overtime.dart';

class RequestOvertimeService {
  String collection = 'requestOvertime';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void update(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).update(values);
  }

  void delete(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).delete();
  }

  Future<RequestOvertimeModel?> selectData({
    required String id,
  }) async {
    RequestOvertimeModel? ret;
    await firestore
        .collection(collection)
        .where('id', isEqualTo: id)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = RequestOvertimeModel.fromSnapshot(value.docs.first);
      }
    });
    return ret;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList({
    required List<int> approval,
  }) {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('approval', whereIn: approval)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  bool checkAlert({
    required QuerySnapshot<Map<String, dynamic>>? data,
  }) {
    bool ret = false;
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      RequestOvertimeModel overtime = RequestOvertimeModel.fromSnapshot(doc);
      if (overtime.approval == 0) {
        ret = true;
      }
    }
    return ret;
  }

  List<RequestOvertimeModel> generateList(
    QuerySnapshot<Map<String, dynamic>>? data,
  ) {
    List<RequestOvertimeModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ret.add(RequestOvertimeModel.fromSnapshot(doc));
    }
    return ret;
  }
}
