import 'package:cloud_firestore/cloud_firestore.dart';

class LogModel {
  String _id = '';
  String _organizationId = '';
  String _content = '';
  String _device = '';
  String _createdUserId = '';
  String _createdUserName = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  String get content => _content;
  String get device => _device;
  String get createdUserId => _createdUserId;
  String get createdUserName => _createdUserName;
  DateTime get createdAt => _createdAt;

  LogModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _content = data['content'] ?? '';
    _device = data['device'] ?? '';
    _createdUserId = data['createdUserId'] ?? '';
    _createdUserName = data['createdUserName'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }
}
