import 'package:cloud_firestore/cloud_firestore.dart';

class PlanGarbagemanModel {
  String _id = '';
  String _organizationId = '';
  String _content = '';
  DateTime _eventAt = DateTime.now();
  DateTime _createdAt = DateTime.now();
  DateTime _expirationAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  String get content => _content;
  DateTime get eventAt => _eventAt;
  DateTime get createdAt => _createdAt;
  DateTime get expirationAt => _expirationAt;

  PlanGarbagemanModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _content = data['content'] ?? '';
    _eventAt = data['eventAt'].toDate() ?? DateTime.now();
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
    _expirationAt = data['expirationAt'].toDate() ?? DateTime.now();
  }
}
