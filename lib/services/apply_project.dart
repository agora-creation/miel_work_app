import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/models/apply_project.dart';
import 'package:miel_work_app/models/organization_group.dart';

class ApplyProjectService {
  String collection = 'applyProject';
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
    required int approval,
    required DateTime? searchStart,
    required DateTime? searchEnd,
  }) {
    if (searchStart != null && searchEnd != null) {
      Timestamp startAt = convertTimestamp(searchStart, false);
      Timestamp endAt = convertTimestamp(searchEnd, true);
      return FirebaseFirestore.instance
          .collection(collection)
          .where('organizationId', isEqualTo: organizationId ?? 'error')
          .where('approval', isEqualTo: approval)
          .startAt([endAt])
          .endAt([startAt])
          .orderBy('createdAt', descending: true)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection(collection)
          .where('organizationId', isEqualTo: organizationId ?? 'error')
          .where('approval', isEqualTo: approval)
          .orderBy('createdAt', descending: true)
          .snapshots();
    }
  }

  List<ApplyProjectModel> generateList({
    required QuerySnapshot<Map<String, dynamic>>? data,
    required OrganizationGroupModel? currentGroup,
  }) {
    List<ApplyProjectModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ApplyProjectModel project = ApplyProjectModel.fromSnapshot(doc);
      if (currentGroup == null) {
        ret.add(project);
      } else if (project.groupId == currentGroup.id || project.groupId == '') {
        ret.add(project);
      }
    }
    return ret;
  }
}
