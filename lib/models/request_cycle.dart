import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/approval_user.dart';
import 'package:miel_work_app/models/comment.dart';

class RequestCycleModel {
  String _id = '';
  String _companyName = '';
  String _companyUserName = '';
  String _companyUserEmail = '';
  String _companyUserTel = '';
  String _companyAddress = '';
  String _lockNumber = '';
  List<CommentModel> comments = [];
  bool _pending = false;
  int _approval = 0;
  DateTime _approvedAt = DateTime.now();
  List<ApprovalUserModel> approvalUsers = [];
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get companyName => _companyName;
  String get companyUserName => _companyUserName;
  String get companyUserEmail => _companyUserEmail;
  String get companyUserTel => _companyUserTel;
  String get companyAddress => _companyAddress;
  String get lockNumber => _lockNumber;
  bool get pending => _pending;
  int get approval => _approval;
  DateTime get approvedAt => _approvedAt;
  DateTime get createdAt => _createdAt;

  RequestCycleModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _companyName = data['companyName'] ?? '';
    _companyUserName = data['companyUserName'] ?? '';
    _companyUserEmail = data['companyUserEmail'] ?? '';
    _companyUserTel = data['companyUserTel'] ?? '';
    _companyAddress = data['companyAddress'] ?? '';
    _lockNumber = data['lockNumber'] ?? '';
    comments = _convertComments(data['comments'] ?? []);
    _pending = data['pending'] ?? false;
    _approval = data['approval'] ?? 0;
    _approvedAt = data['approvedAt'].toDate() ?? DateTime.now();
    approvalUsers = _convertApprovalUsers(data['approvalUsers'] ?? []);
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }

  List<CommentModel> _convertComments(List list) {
    List<CommentModel> converted = [];
    for (Map data in list) {
      converted.add(CommentModel.fromMap(data));
    }
    return converted;
  }

  List<ApprovalUserModel> _convertApprovalUsers(List list) {
    List<ApprovalUserModel> converted = [];
    for (Map data in list) {
      converted.add(ApprovalUserModel.fromMap(data));
    }
    return converted;
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
