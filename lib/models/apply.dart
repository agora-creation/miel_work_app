import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:miel_work_app/models/approval_user.dart';

const List<String> kApplyTypes = ['稟議', '協議・報告', '企画'];

class ApplyModel {
  String _id = '';
  String _organizationId = '';
  String _groupId = '';
  String _type = '';
  String _title = '';
  String _content = '';
  int _price = 0;
  String _file = '';
  String _fileExt = '';
  String _reason = '';
  int _approval = 0;
  DateTime _approvedAt = DateTime.now();
  List<ApprovalUserModel> approvalUsers = [];
  String _createdUserId = '';
  String _createdUserName = '';
  DateTime _createdAt = DateTime.now();
  DateTime _expirationAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  String get groupId => _groupId;
  String get type => _type;
  String get title => _title;
  String get content => _content;
  int get price => _price;
  String get file => _file;
  String get fileExt => _fileExt;
  String get reason => _reason;
  int get approval => _approval;
  DateTime get approvedAt => _approvedAt;
  String get createdUserId => _createdUserId;
  String get createdUserName => _createdUserName;
  DateTime get createdAt => _createdAt;
  DateTime get expirationAt => _expirationAt;

  ApplyModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _groupId = data['groupId'] ?? '';
    _type = data['type'] ?? '';
    _title = data['title'] ?? '';
    _content = data['content'] ?? '';
    _price = data['price'] ?? 0;
    _file = data['file'] ?? '';
    _fileExt = data['fileExt'] ?? '';
    _reason = data['reason'] ?? '';
    _approval = data['approval'] ?? 0;
    _approvedAt = data['approvedAt'].toDate() ?? DateTime.now();
    approvalUsers = _convertApprovalUsers(data['approvalUsers']);
    _createdUserId = data['createdUserId'] ?? '';
    _createdUserName = data['createdUserName'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
    _expirationAt = data['expirationAt'].toDate() ?? DateTime.now();
  }

  List<ApprovalUserModel> _convertApprovalUsers(List list) {
    List<ApprovalUserModel> converted = [];
    for (Map data in list) {
      converted.add(ApprovalUserModel.fromMap(data));
    }
    return converted;
  }

  String formatPrice() {
    return NumberFormat("#,###").format(_price);
  }

  String approvalText() {
    switch (_approval) {
      case 0:
        return '承認待ち';
      case 1:
        return '承認済み';
      case 9:
        return '否決';
      default:
        return '承認待ち';
    }
  }
}
