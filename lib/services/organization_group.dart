import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/organization_group.dart';

class OrganizationGroupService {
  String collection = 'organization';
  String subCollection = 'group';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<OrganizationGroupModel?> selectData({
    required String organizationId,
    required String userId,
  }) async {
    OrganizationGroupModel? ret;
    await firestore
        .collection(collection)
        .doc(organizationId)
        .collection(subCollection)
        .where('userIds', arrayContains: userId)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = OrganizationGroupModel.fromSnapshot(value.docs.first);
      }
    });
    return ret;
  }
}
