import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/approval_user.dart';

class RequestSquareModel {
  String _id = '';
  String _companyName = '';
  String _companyUserName = '';
  String _companyUserEmail = '';
  String _companyUserTel = '';
  String _companyAddress = '';
  String _useCompanyName = '';
  String _useCompanyUserName = '';
  DateTime _useStartedAt = DateTime.now();
  DateTime _useEndedAt = DateTime.now();
  bool _useAtPending = false;
  bool _useFull = false;
  bool _useChair = false;
  int _useChairNum = 0;
  bool _useDesk = false;
  int _useDeskNum = 0;
  String _useContent = '';
  List<String> attachedFiles = [];
  String _memo = '';
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
  String get useCompanyName => _useCompanyName;
  String get useCompanyUserName => _useCompanyUserName;
  DateTime get useStartedAt => _useStartedAt;
  DateTime get useEndedAt => _useEndedAt;
  bool get useAtPending => _useAtPending;
  bool get useFull => _useFull;
  bool get useChair => _useChair;
  int get useChairNum => _useChairNum;
  bool get useDesk => _useDesk;
  int get useDeskNum => _useDeskNum;
  String get useContent => _useContent;
  String get memo => _memo;
  int get approval => _approval;
  DateTime get approvedAt => _approvedAt;
  DateTime get createdAt => _createdAt;

  RequestSquareModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _companyName = data['companyName'] ?? '';
    _companyUserName = data['companyUserName'] ?? '';
    _companyUserEmail = data['companyUserEmail'] ?? '';
    _companyUserTel = data['companyUserTel'] ?? '';
    _companyAddress = data['companyAddress'] ?? '';
    _useCompanyName = data['useCompanyName'] ?? '';
    _useCompanyUserName = data['useCompanyUserName'] ?? '';
    _useStartedAt = data['useStartedAt'].toDate() ?? DateTime.now();
    _useEndedAt = data['useEndedAt'].toDate() ?? DateTime.now();
    _useAtPending = data['useAtPending'] ?? false;
    _useFull = data['useFull'] ?? false;
    _useChair = data['useChair'] ?? false;
    _useChairNum = data['useChairNum'] ?? 0;
    _useDesk = data['useDesk'] ?? false;
    _useDeskNum = data['useDeskNum'] ?? 0;
    _useContent = data['useContent'] ?? '';
    attachedFiles = _convertAttachedFiles(data['attachedFiles'] ?? []);
    _memo = data['memo'] ?? '';
    _approval = data['approval'] ?? 0;
    _approvedAt = data['approvedAt'].toDate() ?? DateTime.now();
    approvalUsers = _convertApprovalUsers(data['approvalUsers']);
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }

  List<String> _convertAttachedFiles(List list) {
    List<String> converted = [];
    for (String data in list) {
      converted.add(data);
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
