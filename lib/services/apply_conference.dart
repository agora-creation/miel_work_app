import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/apply_conference.dart';
import 'package:miel_work_app/models/organization_group.dart';

class ApplyConferenceService {
  String collection = 'applyConference';
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
    required bool approval,
  }) {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId ?? 'error')
        .where('approval', isEqualTo: approval)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  List<ApplyConferenceModel> generateList({
    required QuerySnapshot<Map<String, dynamic>>? data,
    required OrganizationGroupModel? currentGroup,
  }) {
    List<ApplyConferenceModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ApplyConferenceModel conference = ApplyConferenceModel.fromSnapshot(doc);
      if (currentGroup == null) {
        ret.add(conference);
      } else if (conference.groupId == currentGroup.id ||
          conference.groupId == '') {
        ret.add(conference);
      }
    }
    return ret;
  }
}
