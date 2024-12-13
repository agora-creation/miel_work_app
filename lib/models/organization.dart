import 'package:cloud_firestore/cloud_firestore.dart';

class OrganizationModel {
  String _id = '';
  String _name = '';
  List<String> userIds = [];
  String _loginId = '';
  String _password = '';
  String _shiftLoginId = '';
  String _shiftPassword = '';
  String _contact = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get name => _name;
  String get loginId => _loginId;
  String get password => _password;
  String get shiftLoginId => _shiftLoginId;
  String get shiftPassword => _shiftPassword;
  String get contact => _contact;
  DateTime get createdAt => _createdAt;

  OrganizationModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _name = data['name'] ?? '';
    userIds = _convertUserIds(data['userIds'] ?? []);
    _loginId = data['loginId'] ?? '';
    _password = data['password'] ?? '';
    _shiftLoginId = data['shiftLoginId'] ?? '';
    _shiftPassword = data['shiftPassword'] ?? '';
    _contact = data['contact'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }

  List<String> _convertUserIds(List list) {
    List<String> ret = [];
    for (dynamic id in list) {
      ret.add('$id');
    }
    return ret;
  }
}
