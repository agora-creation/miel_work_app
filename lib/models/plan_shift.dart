import 'package:cloud_firestore/cloud_firestore.dart';

class PlanShiftModel {
  String _id = '';
  String _organizationId = '';
  String _groupId = '';
  List<String> userIds = [];
  DateTime _startedAt = DateTime.now();
  DateTime _endedAt = DateTime.now();
  bool _allDay = false;
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  String get groupId => _groupId;
  DateTime get startedAt => _startedAt;
  DateTime get endedAt => _endedAt;
  bool get allDay => _allDay;
  DateTime get createdAt => _createdAt;

  PlanShiftModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _groupId = data['groupId'] ?? '';
    userIds = _convertUserIds(data['userIds']);
    _startedAt = data['startedAt'].toDate() ?? DateTime.now();
    _endedAt = data['endedAt'].toDate() ?? DateTime.now();
    _allDay = data['allDay'] ?? false;
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }

  List<String> _convertUserIds(List list) {
    List<String> ret = [];
    for (dynamic id in list) {
      ret.add('$id');
    }
    return ret;
  }
}
