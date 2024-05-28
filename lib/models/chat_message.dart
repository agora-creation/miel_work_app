import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/read_user.dart';
import 'package:miel_work_app/models/reply_source.dart';

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
  List<String> favoriteUserIds = [];
  String _createdUserId = '';
  String _createdUserName = '';
  DateTime _createdAt = DateTime.now();
  DateTime _expirationAt = DateTime.now();
  ReplySourceModel? _replySource;

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
  ReplySourceModel? get replySource => _replySource;

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
    readUsers = _convertReadUsers(data['readUsers'] ?? []);
    favoriteUserIds = _convertFavoriteUserIds(data['favoriteUserIds'] ?? []);
    _createdUserId = data['createdUserId'] ?? '';
    _createdUserName = data['createdUserName'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
    _expirationAt = data['expirationAt'].toDate() ?? DateTime.now();
    _replySource = _convertReplySource(data['replySource']);
  }

  List<ReadUserModel> _convertReadUsers(List list) {
    List<ReadUserModel> converted = [];
    for (Map data in list) {
      converted.add(ReadUserModel.fromMap(data));
    }
    return converted;
  }

  List<String> _convertFavoriteUserIds(List list) {
    List<String> converted = [];
    for (String data in list) {
      converted.add(data);
    }
    return converted;
  }

  ReplySourceModel? _convertReplySource(Map? data) {
    ReplySourceModel? ret;
    if (data != null) {
      ret = ReplySourceModel.fromMap(data);
    }
    return ret;
  }
}
