import 'package:cloud_firestore/cloud_firestore.dart';

class PlanDishCenterModel {
  String _id = '';
  String _organizationId = '';
  String _userId = '';
  String _userName = '';
  DateTime _startedAt = DateTime.now();
  DateTime _endedAt = DateTime.now();
  String _remarks = '';
  DateTime _createdAt = DateTime.now();
  DateTime _expirationAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  String get userId => _userId;
  String get userName => _userName;
  DateTime get startedAt => _startedAt;
  DateTime get endedAt => _endedAt;
  String get remarks => _remarks;
  DateTime get createdAt => _createdAt;
  DateTime get expirationAt => _expirationAt;

  PlanDishCenterModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _userId = data['userId'] ?? '';
    _userName = data['userName'] ?? '';
    _startedAt = data['startedAt'].toDate() ?? DateTime.now();
    _endedAt = data['endedAt'].toDate() ?? DateTime.now();
    _remarks = data['remarks'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
    _expirationAt = data['expirationAt'].toDate() ?? DateTime.now();
  }
}
