import 'package:cloud_firestore/cloud_firestore.dart';

class MailModel {
  String _id = '';
  String _to = '';
  String _subject = '';
  String _message = '';
  DateTime _createdAt = DateTime.now();
  DateTime _expirationAt = DateTime.now();

  String get id => _id;
  String get to => _to;
  String get subject => _subject;
  String get message => _message;
  DateTime get createdAt => _createdAt;
  DateTime get expirationAt => _expirationAt;

  MailModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _to = data['to'] ?? '';
    _subject = data['subject'] ?? '';
    _message = data['message'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
    _expirationAt = data['expirationAt'].toDate() ?? DateTime.now();
  }
}
