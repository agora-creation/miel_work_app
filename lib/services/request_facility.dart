import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/request_facility.dart';

class RequestFacilityService {
  String collection = 'requestFacility';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void update(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).update(values);
  }

  void delete(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).delete();
  }

  Future<RequestFacilityModel?> selectData({
    required String id,
  }) async {
    RequestFacilityModel? ret;
    await firestore
        .collection(collection)
        .where('id', isEqualTo: id)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = RequestFacilityModel.fromSnapshot(value.docs.first);
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
      RequestFacilityModel facility = RequestFacilityModel.fromSnapshot(doc);
      if (facility.approval == 0) {
        ret = true;
      }
    }
    return ret;
  }

  List<RequestFacilityModel> generateList(
    QuerySnapshot<Map<String, dynamic>>? data,
  ) {
    List<RequestFacilityModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ret.add(RequestFacilityModel.fromSnapshot(doc));
    }
    return ret;
  }
}
