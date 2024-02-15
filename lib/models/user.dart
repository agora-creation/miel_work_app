import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String _id = '';
  String _name = '';
  String _email = '';
  String _password = '';
  String _uid = '';
  String _token = '';
  String _organizationId = '';
  List<String> _groupIds = [];
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get uid => _uid;
  String get token => _token;
  String get organizationId => _organizationId;
  List<String> get groupIds => _groupIds;
  DateTime get createdAt => _createdAt;

  UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _name = data['name'] ?? '';
    _email = data['email'] ?? '';
    _password = data['password'] ?? '';
    _uid = data['uid'] ?? '';
    _token = data['token'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _groupIds = data['groupIds'] ?? [];
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }

  UserModel.fromMap(Map data) {
    _id = data['id'] ?? '';
    _name = data['name'] ?? '';
    _email = data['email'] ?? '';
    _password = data['password'] ?? '';
    _uid = data['uid'] ?? '';
    _token = data['token'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _groupIds = data['groupIds'] ?? [];
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }

  Map toMap() => {
        'id': _id,
        'name': _name,
        'email': _email,
        'password': _password,
        'uid': _uid,
        'token': _token,
        'organizationId': _organizationId,
        'groupIds': _groupIds,
        'createdAt': _createdAt,
      };
}
