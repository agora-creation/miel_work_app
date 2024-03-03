import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  String _id = '';
  String _chatId = '';
  String _userId = '';
  String _content = '';
  String _image = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get chatId => _chatId;
  String get userId => _userId;
  String get content => _content;
  String get image => _image;
  DateTime get createdAt => _createdAt;

  ChatMessageModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _chatId = data['chatId'] ?? '';
    _userId = data['userId'] ?? '';
    _content = data['content'] ?? '';
    _image = data['image'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }
}
