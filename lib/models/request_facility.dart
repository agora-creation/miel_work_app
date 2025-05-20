import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/approval_user.dart';
import 'package:miel_work_app/models/comment.dart';

class RequestFacilityModel {
  String _id = '';
  String _companyName = '';
  String _companyUserName = '';
  String _companyUserEmail = '';
  String _companyUserTel = '';
  String _useLocationFile = '';
  DateTime _useStartedAt = DateTime.now();
  DateTime _useEndedAt = DateTime.now();
  bool _useAtPending = false;
  List<String> attachedFiles = [];
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
  String get useLocationFile => _useLocationFile;
  DateTime get useStartedAt => _useStartedAt;
  DateTime get useEndedAt => _useEndedAt;
  bool get useAtPending => _useAtPending;
  bool get pending => _pending;
  int get approval => _approval;
  DateTime get approvedAt => _approvedAt;
  DateTime get createdAt => _createdAt;

  RequestFacilityModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _companyName = data['companyName'] ?? '';
    _companyUserName = data['companyUserName'] ?? '';
    _companyUserEmail = data['companyUserEmail'] ?? '';
    _companyUserTel = data['companyUserTel'] ?? '';
    _useLocationFile = data['useLocationFile'] ?? '';
    _useStartedAt = data['useStartedAt'].toDate() ?? DateTime.now();
    _useEndedAt = data['useEndedAt'].toDate() ?? DateTime.now();
    _useAtPending = data['useAtPending'] ?? false;
    attachedFiles = _convertAttachedFiles(data['attachedFiles'] ?? []);
    comments = _convertComments(data['comments'] ?? []);
    _pending = data['pending'] ?? false;
    _approval = data['approval'] ?? 0;
    _approvedAt = data['approvedAt'].toDate() ?? DateTime.now();
    approvalUsers = _convertApprovalUsers(data['approvalUsers'] ?? []);
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }

  List<String> _convertAttachedFiles(List list) {
    List<String> converted = [];
    for (String data in list) {
      converted.add(data);
    }
    return converted;
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
