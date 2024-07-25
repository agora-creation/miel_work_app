import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/plan.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;

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
    required DateTime date,
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
        var dateS = DateTime(date.year, date.month, date.day, 0, 0, 0);
        var dateE = DateTime(date.year, date.month, date.day, 23, 59, 59);
        if (plan.startedAt.millisecondsSinceEpoch <=
                dateS.millisecondsSinceEpoch &&
            dateS.millisecondsSinceEpoch <=
                plan.endedAt.millisecondsSinceEpoch) {
          listIn = true;
        } else if (dateS.millisecondsSinceEpoch <=
                plan.startedAt.millisecondsSinceEpoch &&
            plan.endedAt.millisecondsSinceEpoch <=
                dateE.millisecondsSinceEpoch) {
          listIn = true;
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
    required List<String> categories,
  }) {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId ?? 'error')
        .where('category', whereIn: categories.isNotEmpty ? categories : null)
        .orderBy('startedAt', descending: true)
        .snapshots();
  }

  List<PlanModel> generateList({
    required QuerySnapshot<Map<String, dynamic>>? data,
    required OrganizationGroupModel? currentGroup,
    DateTime? date,
    bool shift = false,
  }) {
    List<PlanModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      PlanModel plan = PlanModel.fromSnapshot(doc);
      bool listIn = false;
      if (currentGroup == null) {
        if (date != null) {
          var dateS = DateTime(date.year, date.month, date.day, 0, 0, 0);
          var dateE = DateTime(date.year, date.month, date.day, 23, 59, 59);
          if (plan.startedAt.millisecondsSinceEpoch <=
                  dateS.millisecondsSinceEpoch &&
              dateS.millisecondsSinceEpoch <=
                  plan.endedAt.millisecondsSinceEpoch) {
            listIn = true;
          } else if (dateS.millisecondsSinceEpoch <=
                  plan.startedAt.millisecondsSinceEpoch &&
              plan.endedAt.millisecondsSinceEpoch <=
                  dateE.millisecondsSinceEpoch) {
            listIn = true;
          }
        } else {
          listIn = true;
        }
      } else {
        if (currentGroup.id == plan.groupId || plan.groupId == '') {
          if (date != null) {
            var dateS = DateTime(date.year, date.month, date.day, 0, 0, 0);
            var dateE = DateTime(date.year, date.month, date.day, 23, 59, 59);
            if (plan.startedAt.millisecondsSinceEpoch <=
                    dateS.millisecondsSinceEpoch &&
                dateS.millisecondsSinceEpoch <=
                    plan.endedAt.millisecondsSinceEpoch) {
              listIn = true;
            } else if (dateS.millisecondsSinceEpoch <=
                    plan.startedAt.millisecondsSinceEpoch &&
                plan.endedAt.millisecondsSinceEpoch <=
                    dateE.millisecondsSinceEpoch) {
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

  List<sfc.Appointment> generateListAppointment({
    required QuerySnapshot<Map<String, dynamic>>? data,
    required OrganizationGroupModel? currentGroup,
    DateTime? date,
    bool shift = false,
  }) {
    List<sfc.Appointment> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      PlanModel plan = PlanModel.fromSnapshot(doc);
      bool listIn = false;
      if (currentGroup == null) {
        if (date != null) {
          var dateS = DateTime(date.year, date.month, date.day, 0, 0, 0);
          var dateE = DateTime(date.year, date.month, date.day, 23, 59, 59);
          if (plan.startedAt.millisecondsSinceEpoch <=
                  dateS.millisecondsSinceEpoch &&
              dateS.millisecondsSinceEpoch <=
                  plan.endedAt.millisecondsSinceEpoch) {
            listIn = true;
          } else if (dateS.millisecondsSinceEpoch <=
                  plan.startedAt.millisecondsSinceEpoch &&
              plan.endedAt.millisecondsSinceEpoch <=
                  dateE.millisecondsSinceEpoch) {
            listIn = true;
          }
        } else {
          listIn = true;
        }
      } else {
        if (currentGroup.id == plan.groupId || plan.groupId == '') {
          if (date != null) {
            var dateS = DateTime(date.year, date.month, date.day, 0, 0, 0);
            var dateE = DateTime(date.year, date.month, date.day, 23, 59, 59);
            if (plan.startedAt.millisecondsSinceEpoch <=
                    dateS.millisecondsSinceEpoch &&
                dateS.millisecondsSinceEpoch <=
                    plan.endedAt.millisecondsSinceEpoch) {
              listIn = true;
            } else if (dateS.millisecondsSinceEpoch <=
                    plan.startedAt.millisecondsSinceEpoch &&
                plan.endedAt.millisecondsSinceEpoch <=
                    dateE.millisecondsSinceEpoch) {
              listIn = true;
            }
          } else {
            listIn = true;
          }
        }
      }
      if (listIn) {
        ret.add(sfc.Appointment(
          id: plan.id,
          resourceIds: plan.userIds,
          subject: '[${plan.category}]${plan.subject}',
          startTime: plan.startedAt,
          endTime: plan.endedAt,
          isAllDay: plan.allDay,
          color:
              shift ? plan.categoryColor.withOpacity(0.3) : plan.categoryColor,
          notes: 'plan',
          recurrenceRule: plan.getRepeatRule(),
        ));
      }
    }
    return ret;
  }
}
