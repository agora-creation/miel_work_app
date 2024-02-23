import 'package:cloud_firestore/cloud_firestore.dart';

class NoticeModel {
  String _id = '';
  String _organizationId = '';
  String _groupId = '';
  String _title = '';
  String _content = '';
  String _file = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  String get groupId => _groupId;
  String get title => _title;
  String get content => _content;
  String get file => _file;
  DateTime get createdAt => _createdAt;

  NoticeModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _groupId = data['groupId'] ?? '';
    _title = data['title'] ?? '';
    _content = data['content'] ?? '';
    _file = data['file'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }
}
