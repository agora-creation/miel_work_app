import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/apply.dart';
import 'package:miel_work_app/models/organization_group.dart';

class ApplyService {
  String collection = 'apply';
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

  Future<ApplyModel?> selectData({
    required String id,
  }) async {
    ApplyModel? ret;
    await firestore
        .collection(collection)
        .where('id', isEqualTo: id)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = ApplyModel.fromSnapshot(value.docs.first);
      }
    });
    return ret;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList({
    required String? organizationId,
    required List<int> approval,
  }) {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId ?? 'error')
        .where('approval', whereIn: approval)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  bool checkAlert({
    required QuerySnapshot<Map<String, dynamic>>? data,
  }) {
    bool ret = false;
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ApplyModel apply = ApplyModel.fromSnapshot(doc);
      if (apply.approval == 0) {
        ret = true;
      }
    }
    return ret;
  }

  List<ApplyModel> generateList({
    required QuerySnapshot<Map<String, dynamic>>? data,
    required OrganizationGroupModel? currentGroup,
    String? keyword,
  }) {
    List<ApplyModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ApplyModel apply = ApplyModel.fromSnapshot(doc);
      if (currentGroup == null) {
        if (keyword != null && keyword != '') {
          if (apply.title.contains(keyword) ||
              apply.content.contains(keyword)) {
            ret.add(apply);
          }
        } else {
          ret.add(apply);
        }
      } else if (apply.groupId == currentGroup.id || apply.groupId == '') {
        if (keyword != null && keyword != '') {
          if (apply.title.contains(keyword) ||
              apply.content.contains(keyword)) {
            ret.add(apply);
          }
        } else {
          ret.add(apply);
        }
      }
    }
    return ret;
  }
}
