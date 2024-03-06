import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  String _id = '';
  String _organizationId = '';
  String _groupId = '';
  String _chatId = '';
  String _content = '';
  String _image = '';
  List<String> readUserIds = [];
  String _createdUserId = '';
  String _createdUserName = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  String get groupId => _groupId;
  String get chatId => _chatId;
  String get content => _content;
  String get image => _image;
  String get createdUserId => _createdUserId;
  String get createdUserName => _createdUserName;
  DateTime get createdAt => _createdAt;

  ChatMessageModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _groupId = data['groupId'] ?? '';
    _chatId = data['chatId'] ?? '';
    _content = data['content'] ?? '';
    _image = data['image'] ?? '';
    readUserIds = _convertReadUserIds(data['readUserIds']);
    _createdUserId = data['createdUserId'] ?? '';
    _createdUserName = data['createdUserName'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }

  List<String> _convertReadUserIds(List list) {
    List<String> ret = [];
    for (dynamic id in list) {
      ret.add('$id');
    }
    return ret;
  }
}
