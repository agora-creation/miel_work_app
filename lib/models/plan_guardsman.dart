import 'package:cloud_firestore/cloud_firestore.dart';

class PlanGuardsmanModel {
  String _id = '';
  String _organizationId = '';
  DateTime _startedAt = DateTime.now();
  DateTime _endedAt = DateTime.now();
  String _remarks = '';
  DateTime _createdAt = DateTime.now();
  DateTime _expirationAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  DateTime get startedAt => _startedAt;
  DateTime get endedAt => _endedAt;
  String get remarks => _remarks;
  DateTime get createdAt => _createdAt;
  DateTime get expirationAt => _expirationAt;

  PlanGuardsmanModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _startedAt = data['startedAt'].toDate() ?? DateTime.now();
    _endedAt = data['endedAt'].toDate() ?? DateTime.now();
    _remarks = data['remarks'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
    _expirationAt = data['expirationAt'].toDate() ?? DateTime.now();
  }
}
