import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/common/functions.dart';
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
