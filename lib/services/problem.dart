import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/models/problem.dart';
import 'package:miel_work_app/models/user.dart';

class ProblemService {
  String collection = 'problem';
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

  Future<List<ProblemModel>> selectList({
    required String? organizationId,
    required DateTime? searchStart,
    required DateTime? searchEnd,
  }) async {
    List<ProblemModel> ret = [];
    if (searchStart != null && searchEnd != null) {
      Timestamp startAt = convertTimestamp(searchStart, false);
      Timestamp endAt = convertTimestamp(searchEnd, true);
      await firestore
          .collection(collection)
          .where('organizationId', isEqualTo: organizationId ?? 'error')
          .orderBy('createdAt', descending: true)
          .startAt([endAt])
          .endAt([startAt])
          .get()
          .then((value) {
            for (DocumentSnapshot<Map<String, dynamic>> map in value.docs) {
              ret.add(ProblemModel.fromSnapshot(map));
            }
          });
    } else {
      await firestore
          .collection(collection)
          .where('organizationId', isEqualTo: organizationId ?? 'error')
          .orderBy('createdAt', descending: true)
          .get()
          .then((value) {
        for (DocumentSnapshot<Map<String, dynamic>> map in value.docs) {
          ret.add(ProblemModel.fromSnapshot(map));
        }
      });
    }
    return ret;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList({
    required String? organizationId,
    required DateTime? searchStart,
    required DateTime? searchEnd,
    required bool processed,
  }) {
    if (searchStart != null && searchEnd != null) {
      Timestamp startAt = convertTimestamp(searchStart, false);
      Timestamp endAt = convertTimestamp(searchEnd, true);
      return FirebaseFirestore.instance
          .collection(collection)
          .where('organizationId', isEqualTo: organizationId ?? 'error')
          .where('processed', isEqualTo: processed)
          .orderBy('createdAt', descending: true)
          .startAt([endAt]).endAt([startAt]).snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection(collection)
          .where('organizationId', isEqualTo: organizationId ?? 'error')
          .where('processed', isEqualTo: processed)
          .orderBy('createdAt', descending: true)
          .snapshots();
    }
  }

  bool checkAlert({
    required QuerySnapshot<Map<String, dynamic>>? data,
    required UserModel? user,
  }) {
    bool ret = false;
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ProblemModel problem = ProblemModel.fromSnapshot(doc);
      ret = !problem.readUserIds.contains(user?.id);
      if (ret) {
        return ret;
      }
    }
    return ret;
  }

  List<ProblemModel> generateList({
    required QuerySnapshot<Map<String, dynamic>>? data,
  }) {
    List<ProblemModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ret.add(ProblemModel.fromSnapshot(doc));
    }
    return ret;
  }
}
