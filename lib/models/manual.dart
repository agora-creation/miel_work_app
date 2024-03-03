import 'package:cloud_firestore/cloud_firestore.dart';

class ManualModel {
  String _id = '';
  String _organizationId = '';
  String _groupId = '';
  String _title = '';
  String _file = '';
  List<String> readUserIds = [];
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  String get groupId => _groupId;
  String get title => _title;
  String get file => _file;
  DateTime get createdAt => _createdAt;

  ManualModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _groupId = data['groupId'] ?? '';
    _title = data['title'] ?? '';
    _file = data['file'] ?? '';
    readUserIds = _convertReadUserIds(data['readUserIds']);
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
