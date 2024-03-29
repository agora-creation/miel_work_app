import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/models/manual.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/user.dart';

class ManualService {
  String collection = 'manual';
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
          .orderBy('createdAt', descending: true)
          .startAt([endAt]).endAt([startAt]).snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection(collection)
          .where('organizationId', isEqualTo: organizationId ?? 'error')
          .orderBy('createdAt', descending: true)
          .snapshots();
    }
  }

  bool checkAlert({
    required QuerySnapshot<Map<String, dynamic>>? data,
    required OrganizationGroupModel? currentGroup,
    required UserModel? user,
  }) {
    bool ret = false;
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ManualModel manual = ManualModel.fromSnapshot(doc);
      if (currentGroup == null) {
        ret = !manual.readUserIds.contains(user?.id);
      } else if (manual.groupId == currentGroup.id || manual.groupId == '') {
        ret = !manual.readUserIds.contains(user?.id);
      }
      if (ret) {
        return ret;
      }
    }
    return ret;
  }

  List<ManualModel> generateList({
    required QuerySnapshot<Map<String, dynamic>>? data,
    required OrganizationGroupModel? currentGroup,
  }) {
    List<ManualModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ManualModel manual = ManualModel.fromSnapshot(doc);
      if (currentGroup == null) {
        ret.add(manual);
      } else if (manual.groupId == currentGroup.id || manual.groupId == '') {
        ret.add(manual);
      }
    }
    return ret;
  }
}
