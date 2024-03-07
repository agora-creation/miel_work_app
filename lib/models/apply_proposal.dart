import 'package:cloud_firestore/cloud_firestore.dart';

class ApplyProposalModel {
  String _id = '';
  String _organizationId = '';
  String _groupId = '';
  String _title = '';
  String _content = '';
  int _price = 0;
  bool _approval = false;
  List<String> approvalUserIds = [];
  String _createdUserId = '';
  String _createdUserName = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  String get groupId => _groupId;
  String get title => _title;
  String get content => _content;
  int get price => _price;
  bool get approval => _approval;
  String get createdUserId => _createdUserId;
  String get createdUserName => _createdUserName;
  DateTime get createdAt => _createdAt;

  ApplyProposalModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _groupId = data['groupId'] ?? '';
    _title = data['title'] ?? '';
    _content = data['content'] ?? '';
    _price = data['price'] ?? 0;
    _approval = data['approval'] ?? false;
    approvalUserIds = _convertApprovalUserIds(data['approvalUserIds']);
    _createdUserId = data['createdUserId'] ?? '';
    _createdUserName = data['createdUserName'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }

  List<String> _convertApprovalUserIds(List list) {
    List<String> ret = [];
    for (dynamic id in list) {
      ret.add('$id');
    }
    return ret;
  }
}
