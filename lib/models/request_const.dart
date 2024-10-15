import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/approval_user.dart';

class RequestConstModel {
  String _id = '';
  String _companyName = '';
  String _companyUserName = '';
  String _companyUserEmail = '';
  String _companyUserTel = '';
  String _constName = '';
  String _constUserName = '';
  String _constUserTel = '';
  DateTime _constStartedAt = DateTime.now();
  DateTime _constEndedAt = DateTime.now();
  bool _constAtPending = false;
  String _processFile = '';
  String _processFileExt = '';
  String _constContent = '';
  bool _noise = false;
  String _noiseMeasures = '';
  bool _dust = false;
  String _dustMeasures = '';
  bool _fire = false;
  String _fireMeasures = '';
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
  String get constName => _constName;
  String get constUserName => _constUserName;
  String get constUserTel => _constUserTel;
  DateTime get constStartedAt => _constStartedAt;
  DateTime get constEndedAt => _constEndedAt;
  bool get constAtPending => _constAtPending;
  String get processFile => _processFile;
  String get processFileExt => _processFileExt;
  String get constContent => _constContent;
  bool get noise => _noise;
  String get noiseMeasures => _noiseMeasures;
  bool get dust => _dust;
  String get dustMeasures => _dustMeasures;
  bool get fire => _fire;
  String get fireMeasures => _fireMeasures;
  String get memo => _memo;
  int get approval => _approval;
  DateTime get approvedAt => _approvedAt;
  DateTime get createdAt => _createdAt;

  RequestConstModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _companyName = data['companyName'] ?? '';
    _companyUserName = data['companyUserName'] ?? '';
    _companyUserEmail = data['companyUserEmail'] ?? '';
    _companyUserTel = data['companyUserTel'] ?? '';
    _constName = data['constName'] ?? '';
    _constUserName = data['constUserName'] ?? '';
    _constUserTel = data['constUserTel'] ?? '';
    _constStartedAt = data['constStartedAt'].toDate() ?? DateTime.now();
    _constEndedAt = data['constEndedAt'].toDate() ?? DateTime.now();
    _constAtPending = data['constAtPending'] ?? false;
    _processFile = data['processFile'] ?? '';
    _processFileExt = data['processFileExt'] ?? '';
    _constContent = data['constContent'] ?? '';
    _noise = data['noise'] ?? false;
    _noiseMeasures = data['noiseMeasures'] ?? '';
    _dust = data['dust'] ?? false;
    _dustMeasures = data['dustMeasures'] ?? '';
    _fire = data['fire'] ?? false;
    _fireMeasures = data['fireMeasures'] ?? '';
    _memo = data['memo'] ?? '';
    _approval = data['approval'] ?? 0;
    _approvedAt = data['approvedAt'].toDate() ?? DateTime.now();
    approvalUsers = _convertApprovalUsers(data['approvalUsers']);
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
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
