import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/plan_shift.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;

class PlanShiftService {
  String collection = 'planShift';
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

  Future<PlanShiftModel?> selectData({
    required String id,
  }) async {
    PlanShiftModel? ret;
    await firestore
        .collection(collection)
        .where('id', isEqualTo: id)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = PlanShiftModel.fromSnapshot(value.docs.first);
      }
    });
    return ret;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList({
    required String? organizationId,
  }) {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId ?? 'error')
        .orderBy('startedAt', descending: true)
        .snapshots();
  }

  List<sfc.Appointment> generateList({
    required QuerySnapshot<Map<String, dynamic>>? data,
    required OrganizationGroupModel? currentGroup,
  }) {
    List<sfc.Appointment> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      PlanShiftModel planShift = PlanShiftModel.fromSnapshot(doc);
      String startTimeText = dateText('HH:mm', planShift.startedAt);
      String endTimeText = dateText('HH:mm', planShift.endedAt);
      if (currentGroup == null) {
        ret.add(sfc.Appointment(
          id: planShift.id,
          resourceIds: [planShift.userId],
          subject: '勤務予定 $startTimeText～$endTimeText',
          startTime: planShift.startedAt,
          endTime: planShift.endedAt,
          isAllDay: planShift.allDay,
          color: kLightBlue800Color,
          notes: 'planShift',
          recurrenceRule: planShift.getRepeatRule(),
        ));
      } else if (planShift.groupId == currentGroup.id ||
          planShift.groupId == '') {
        ret.add(sfc.Appointment(
          id: planShift.id,
          resourceIds: [planShift.userId],
          subject: '勤務予定 $startTimeText～$endTimeText',
          startTime: planShift.startedAt,
          endTime: planShift.endedAt,
          isAllDay: planShift.allDay,
          color: kLightBlue800Color,
          notes: 'planShift',
          recurrenceRule: planShift.getRepeatRule(),
        ));
      }
    }
    return ret;
  }
}
