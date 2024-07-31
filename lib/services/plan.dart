import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/plan.dart';

class PlanService {
  String collection = 'plan';
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

  Future<PlanModel?> selectData({
    required String id,
  }) async {
    PlanModel? ret;
    await firestore
        .collection(collection)
        .where('id', isEqualTo: id)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = PlanModel.fromSnapshot(value.docs.first);
      }
    });
    return ret;
  }

  Future<List<PlanModel>> selectList({
    required String? organizationId,
    required DateTime? searchStart,
    required DateTime? searchEnd,
  }) async {
    List<PlanModel> ret = [];
    await firestore
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId ?? 'error')
        .orderBy('startedAt', descending: false)
        .get()
        .then((value) {
      for (DocumentSnapshot<Map<String, dynamic>> map in value.docs) {
        PlanModel plan = PlanModel.fromSnapshot(map);
        bool listIn = false;
        if (searchStart != null && searchEnd != null) {
          if (plan.startedAt.millisecondsSinceEpoch <=
                  searchStart.millisecondsSinceEpoch &&
              searchStart.millisecondsSinceEpoch <=
                  plan.endedAt.millisecondsSinceEpoch) {
            listIn = true;
          } else if (searchStart.millisecondsSinceEpoch <=
                  plan.startedAt.millisecondsSinceEpoch &&
              plan.endedAt.millisecondsSinceEpoch <=
                  searchEnd.millisecondsSinceEpoch) {
            listIn = true;
          }
        }
        if (listIn) {
          ret.add(plan);
        }
      }
    });
    return ret;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList({
    required String? organizationId,
    required List<String> searchCategories,
  }) {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId ?? 'error')
        .where('category',
            whereIn: searchCategories.isNotEmpty ? searchCategories : null)
        .orderBy('startedAt', descending: true)
        .snapshots();
  }

  List<PlanModel> generateList({
    required QuerySnapshot<Map<String, dynamic>>? data,
    required OrganizationGroupModel? currentGroup,
    required DateTime? searchStart,
    required DateTime? searchEnd,
    bool shift = false,
  }) {
    List<PlanModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      PlanModel plan = PlanModel.fromSnapshot(doc);
      bool listIn = false;
      if (currentGroup == null) {
        if (searchStart != null && searchEnd != null) {
          if (plan.startedAt.millisecondsSinceEpoch <=
                  searchStart.millisecondsSinceEpoch &&
              searchStart.millisecondsSinceEpoch <=
                  plan.endedAt.millisecondsSinceEpoch) {
            listIn = true;
          } else if (searchStart.millisecondsSinceEpoch <=
                  plan.startedAt.millisecondsSinceEpoch &&
              plan.endedAt.millisecondsSinceEpoch <=
                  searchEnd.millisecondsSinceEpoch) {
            listIn = true;
          }
        } else {
          listIn = true;
        }
      } else {
        if (currentGroup.id == plan.groupId || plan.groupId == '') {
          if (searchStart != null && searchEnd != null) {
            if (plan.startedAt.millisecondsSinceEpoch <=
                    searchStart.millisecondsSinceEpoch &&
                searchStart.millisecondsSinceEpoch <=
                    plan.endedAt.millisecondsSinceEpoch) {
              listIn = true;
            } else if (searchStart.millisecondsSinceEpoch <=
                    plan.startedAt.millisecondsSinceEpoch &&
                plan.endedAt.millisecondsSinceEpoch <=
                    searchEnd.millisecondsSinceEpoch) {
              listIn = true;
            }
          } else {
            listIn = true;
          }
        }
      }
      if (listIn) {
        ret.add(plan);
      }
    }
    return ret;
  }
}
