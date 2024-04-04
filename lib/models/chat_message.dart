import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/read_user.dart';

class ChatMessageModel {
  String _id = '';
  String _organizationId = '';
  String _groupId = '';
  String _chatId = '';
  String _content = '';
  String _image = '';
  String _file = '';
  String _fileExt = '';
  List<ReadUserModel> readUsers = [];
  String _createdUserId = '';
  String _createdUserName = '';
  DateTime _createdAt = DateTime.now();
  DateTime _expirationAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  String get groupId => _groupId;
  String get chatId => _chatId;
  String get content => _content;
  String get image => _image;
  String get file => _file;
  String get fileExt => _fileExt;
  String get createdUserId => _createdUserId;
  String get createdUserName => _createdUserName;
  DateTime get createdAt => _createdAt;
  DateTime get expirationAt => _expirationAt;

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
    _file = data['file'] ?? '';
    _fileExt = data['fileExt'] ?? '';
    readUsers = _convertReadUsers(data['readUsers']);
    _createdUserId = data['createdUserId'] ?? '';
    _createdUserName = data['createdUserName'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
    _expirationAt = data['expirationAt'].toDate() ?? DateTime.now();
  }

  List<ReadUserModel> _convertReadUsers(List list) {
    List<ReadUserModel> converted = [];
    for (Map data in list) {
      converted.add(ReadUserModel.fromMap(data));
    }
    return converted;
  }
}
