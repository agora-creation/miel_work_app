import 'package:cloud_firestore/cloud_firestore.dart';

class OrganizationModel {
  String _id = '';
  String _name = '';
  List<String> adminUserIds = [];
  List<String> userIds = [];
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get name => _name;
  DateTime get createdAt => _createdAt;

  OrganizationModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _name = data['name'] ?? '';
    adminUserIds = _convertAdminUserIds(data['adminUserIds']);
    userIds = _convertUserIds(data['userIds']);
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }

  List<String> _convertAdminUserIds(List list) {
    List<String> ret = [];
    for (dynamic id in list) {
      ret.add('$id');
    }
    return ret;
  }

  List<String> _convertUserIds(List list) {
    List<String> ret = [];
    for (dynamic id in list) {
      ret.add('$id');
    }
    return ret;
  }
}
