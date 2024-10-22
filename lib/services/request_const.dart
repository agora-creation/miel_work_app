import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/models/request_const.dart';

class RequestConstService {
  String collection = 'requestConst';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void update(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).update(values);
  }

  void delete(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).delete();
  }

  Future<RequestConstModel?> selectData({
    required String id,
  }) async {
    RequestConstModel? ret;
    await firestore
        .collection(collection)
        .where('id', isEqualTo: id)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = RequestConstModel.fromSnapshot(value.docs.first);
      }
    });
    return ret;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList({
    required DateTime? searchStart,
    required DateTime? searchEnd,
    required List<int> approval,
  }) {
    if (searchStart != null && searchEnd != null) {
      Timestamp startAt = convertTimestamp(searchStart, false);
      Timestamp endAt = convertTimestamp(searchEnd, true);
      return FirebaseFirestore.instance
          .collection(collection)
          .where('approval', whereIn: approval)
          .orderBy('createdAt', descending: true)
          .startAt([endAt]).endAt([startAt]).snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection(collection)
          .where('approval', whereIn: approval)
          .orderBy('createdAt', descending: true)
          .snapshots();
    }
  }

  bool checkAlert({
    required QuerySnapshot<Map<String, dynamic>>? data,
  }) {
    bool ret = false;
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      RequestConstModel requestConst = RequestConstModel.fromSnapshot(doc);
      if (requestConst.approval == 0) {
        ret = true;
      }
    }
    return ret;
  }

  List<RequestConstModel> generateList(
    QuerySnapshot<Map<String, dynamic>>? data,
  ) {
    List<RequestConstModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ret.add(RequestConstModel.fromSnapshot(doc));
    }
    return ret;
  }
}
