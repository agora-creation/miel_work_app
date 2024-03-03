import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/organization_group.dart';

class OrganizationGroupService {
  String collection = 'organization';
  String subCollection = 'group';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String id({
    required String organizationId,
  }) {
    return firestore
        .collection(collection)
        .doc(organizationId)
        .collection(subCollection)
        .doc()
        .id;
  }

  void create(Map<String, dynamic> values) {
    firestore
        .collection(collection)
        .doc(values['organizationId'])
        .collection(subCollection)
        .doc(values['id'])
        .set(values);
  }

  void update(Map<String, dynamic> values) {
    firestore
        .collection(collection)
        .doc(values['organizationId'])
        .collection(subCollection)
        .doc(values['id'])
        .update(values);
  }

  void delete(Map<String, dynamic> values) {
    firestore
        .collection(collection)
        .doc(values['organizationId'])
        .collection(subCollection)
        .doc(values['id'])
        .delete();
  }

  Future<List<OrganizationGroupModel>> selectList({
    required String organizationId,
  }) async {
    List<OrganizationGroupModel> ret = [];
    await firestore
        .collection(collection)
        .doc(organizationId)
        .collection(subCollection)
        .orderBy('createdAt', descending: false)
        .get()
        .then((value) {
      for (DocumentSnapshot<Map<String, dynamic>> map in value.docs) {
        ret.add(OrganizationGroupModel.fromSnapshot(map));
      }
    });
    return ret;
  }

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
