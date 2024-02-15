import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/group.dart';
import 'package:miel_work_app/models/user.dart';

class OrganizationModel {
  String _id = '';
  String _code = '';
  String _name = '';
  List<GroupModel> groups = [];
  List<UserModel> adminUsers = [];
  List<UserModel> generalUsers = [];
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get code => _code;
  String get name => _name;
  DateTime get createdAt => _createdAt;

  OrganizationModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _code = data['code'] ?? '';
    _name = data['name'] ?? '';
    groups = _convertGroups(data['groups']);
    adminUsers = _convertUsers(data['adminUsers']);
    generalUsers = _convertUsers(data['generalUsers']);
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }

  List<GroupModel> _convertGroups(List list) {
    List<GroupModel> converted = [];
    for (Map data in list) {
      converted.add(GroupModel.fromMap(data));
    }
    return converted;
  }

  List<UserModel> _convertUsers(List list) {
    List<UserModel> converted = [];
    for (Map data in list) {
      converted.add(UserModel.fromMap(data));
    }
    return converted;
  }
}
