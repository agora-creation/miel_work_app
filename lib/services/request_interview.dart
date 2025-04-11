import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/request_interview.dart';

class RequestInterviewService {
  String collection = 'requestInterview';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void update(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).update(values);
  }

  void delete(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).delete();
  }

  Future<RequestInterviewModel?> selectData({
    required String id,
  }) async {
    RequestInterviewModel? ret;
    await firestore
        .collection(collection)
        .where('id', isEqualTo: id)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = RequestInterviewModel.fromSnapshot(value.docs.first);
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
      RequestInterviewModel interview = RequestInterviewModel.fromSnapshot(doc);
      if (interview.approval == 0) {
        ret = true;
      }
    }
    return ret;
  }

  List<RequestInterviewModel> generateList(
    QuerySnapshot<Map<String, dynamic>>? data,
  ) {
    List<RequestInterviewModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ret.add(RequestInterviewModel.fromSnapshot(doc));
    }
    return ret;
  }
}
