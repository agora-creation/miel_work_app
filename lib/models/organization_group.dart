import 'package:cloud_firestore/cloud_firestore.dart';

class OrganizationGroupModel {
  String _id = '';
  String _organizationId = '';
  String _name = '';
  List<String> userIds = [];
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  String get name => _name;
  DateTime get createdAt => _createdAt;

  OrganizationGroupModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _name = data['name'] ?? '';
    userIds = _convertUserIds(data['userIds']);
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
