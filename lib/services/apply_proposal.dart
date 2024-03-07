import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/apply_proposal.dart';
import 'package:miel_work_app/models/organization_group.dart';

class ApplyProposalService {
  String collection = 'applyProposal';
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
  }) {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId ?? 'error')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  List<ApplyProposalModel> generateList({
    required QuerySnapshot<Map<String, dynamic>>? data,
    required OrganizationGroupModel? currentGroup,
  }) {
    List<ApplyProposalModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ApplyProposalModel proposal = ApplyProposalModel.fromSnapshot(doc);
      if (currentGroup == null) {
        ret.add(proposal);
      } else if (proposal.groupId == currentGroup.id ||
          proposal.groupId == '') {
        ret.add(proposal);
      }
    }
    return ret;
  }
}
