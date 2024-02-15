import 'package:cloud_firestore/cloud_firestore.dart';

class PlanModel {
  String _id = '';
  String _organizationId = '';
  String _groupId = '';
  String _userId = '';
  String _title = '';
  String _content = '';
  DateTime _startedAt = DateTime.now();
  DateTime _endedAt = DateTime.now();
  bool _allDay = false;
  String _file = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  String get groupId => _groupId;
  String get userId => _userId;
  String get title => _title;
  String get content => _content;
  DateTime get startedAt => _startedAt;
  DateTime get endedAt => _endedAt;
  bool get allDay => _allDay;
  String get file => _file;
  DateTime get createdAt => _createdAt;

  PlanModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _groupId = data['groupId'] ?? '';
    _userId = data['userId'] ?? '';
    _title = data['title'] ?? '';
    _content = data['content'] ?? '';
    _startedAt = data['startedAt'].toDate() ?? DateTime.now();
    _endedAt = data['endedAt'].toDate() ?? DateTime.now();
    _allDay = data['allDay'] ?? false;
    _file = data['file'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }
}
