import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/approval_user.dart';

class RequestInterviewModel {
  String _id = '';
  String _companyName = '';
  String _companyUserName = '';
  String _companyUserEmail = '';
  String _companyUserTel = '';
  String _mediaName = '';
  String _programName = '';
  String _castInfo = '';
  String _featureContent = '';
  String _publishedAt = '';
  DateTime _interviewedStartedAt = DateTime.now();
  DateTime _interviewedEndedAt = DateTime.now();
  bool _interviewedAtPending = false;
  String _interviewedUserName = '';
  String _interviewedUserTel = '';
  bool _interviewedReserved = false;
  String _interviewedShopName = '';
  String _interviewedVisitors = '';
  String _interviewedContent = '';
  bool _location = false;
  DateTime _locationStartedAt = DateTime.now();
  DateTime _locationEndedAt = DateTime.now();
  bool _locationAtPending = false;
  String _locationUserName = '';
  String _locationUserTel = '';
  String _locationVisitors = '';
  String _locationContent = '';
  bool _insert = false;
  DateTime _insertedStartedAt = DateTime.now();
  DateTime _insertedEndedAt = DateTime.now();
  bool _insertedAtPending = false;
  String _insertedUserName = '';
  String _insertedUserTel = '';
  bool _insertedReserved = false;
  String _insertedShopName = '';
  String _insertedVisitors = '';
  String _insertedContent = '';
  List<String> attachedFiles = [];
  String _remarks = '';
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
  String get mediaName => _mediaName;
  String get programName => _programName;
  String get castInfo => _castInfo;
  String get featureContent => _featureContent;
  String get publishedAt => _publishedAt;
  DateTime get interviewedStartedAt => _interviewedStartedAt;
  DateTime get interviewedEndedAt => _interviewedEndedAt;
  bool get interviewedAtPending => _interviewedAtPending;
  String get interviewedUserName => _interviewedUserName;
  String get interviewedUserTel => _interviewedUserTel;
  bool get interviewedReserved => _interviewedReserved;
  String get interviewedShopName => _interviewedShopName;
  String get interviewedVisitors => _interviewedVisitors;
  String get interviewedContent => _interviewedContent;
  bool get location => _location;
  DateTime get locationStartedAt => _locationStartedAt;
  DateTime get locationEndedAt => _locationEndedAt;
  bool get locationAtPending => _locationAtPending;
  String get locationUserName => _locationUserName;
  String get locationUserTel => _locationUserTel;
  String get locationVisitors => _locationVisitors;
  String get locationContent => _locationContent;
  bool get insert => _insert;
  DateTime get insertedStartedAt => _insertedStartedAt;
  DateTime get insertedEndedAt => _insertedEndedAt;
  bool get insertedAtPending => _insertedAtPending;
  String get insertedUserName => _insertedUserName;
  String get insertedUserTel => _insertedUserTel;
  bool get insertedReserved => _insertedReserved;
  String get insertedShopName => _insertedShopName;
  String get insertedVisitors => _insertedVisitors;
  String get insertedContent => _insertedContent;
  String get remarks => _remarks;
  String get memo => _memo;
  int get approval => _approval;
  DateTime get approvedAt => _approvedAt;
  DateTime get createdAt => _createdAt;

  RequestInterviewModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _companyName = data['companyName'] ?? '';
    _companyUserName = data['companyUserName'] ?? '';
    _companyUserEmail = data['companyUserEmail'] ?? '';
    _companyUserTel = data['companyUserTel'] ?? '';
    _mediaName = data['mediaName'] ?? '';
    _programName = data['programName'] ?? '';
    _castInfo = data['castInfo'] ?? '';
    _featureContent = data['featureContent'] ?? '';
    _publishedAt = data['publishedAt'] ?? '';
    _interviewedStartedAt =
        data['interviewedStartedAt'].toDate() ?? DateTime.now();
    _interviewedEndedAt = data['interviewedEndedAt'].toDate() ?? DateTime.now();
    _interviewedAtPending = data['interviewedAtPending'] ?? false;
    _interviewedUserName = data['interviewedUserName'] ?? '';
    _interviewedUserTel = data['interviewedUserTel'] ?? '';
    _interviewedReserved = data['interviewedReserved'] ?? false;
    _interviewedShopName = data['interviewedShopName'] ?? '';
    _interviewedVisitors = data['interviewedVisitors'] ?? '';
    _interviewedContent = data['interviewedContent'] ?? '';
    _location = data['location'] ?? false;
    _locationStartedAt = data['locationStartedAt'].toDate() ?? DateTime.now();
    _locationEndedAt = data['locationEndedAt'].toDate() ?? DateTime.now();
    _locationAtPending = data['locationAtPending'] ?? false;
    _locationUserName = data['locationUserName'] ?? '';
    _locationUserTel = data['locationUserTel'] ?? '';
    _locationVisitors = data['locationVisitors'] ?? '';
    _locationContent = data['locationContent'] ?? '';
    _insert = data['insert'] ?? false;
    _insertedStartedAt = data['insertedStartedAt'].toDate() ?? DateTime.now();
    _insertedEndedAt = data['insertedEndedAt'].toDate() ?? DateTime.now();
    _insertedAtPending = data['insertedAtPending'] ?? false;
    _insertedUserName = data['insertedUserName'] ?? '';
    _insertedUserTel = data['insertedUserTel'] ?? '';
    _insertedReserved = data['insertedReserved'] ?? false;
    _insertedShopName = data['insertedShopName'] ?? '';
    _insertedVisitors = data['insertedVisitors'] ?? '';
    _insertedContent = data['insertedContent'] ?? '';
    attachedFiles = _convertAttachedFiles(data['attachedFiles'] ?? []);
    _remarks = data['remarks'] ?? '';
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
