import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String _id = '';
  String _organizationId = '';
  String _groupId = '';
  String _userId = '';
  String _name = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  String get groupId => _groupId;
  String get userId => _userId;
  String get name => _name;
  DateTime get createdAt => _createdAt;

  ChatModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _groupId = data['groupId'] ?? '';
    _userId = data['userId'] ?? '';
    _name = data['name'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }
}
