import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  String _id = '';
  String _organizationId = '';
  String _workUser1Name = '';
  String _workUser1Time = '';
  String _workUser2Name = '';
  String _workUser2Time = '';
  String _workUser3Name = '';
  String _workUser3Time = '';
  String _workUser4Name = '';
  String _workUser4Time = '';
  String _workUser5Name = '';
  String _workUser5Time = '';
  String _workUser6Name = '';
  String _workUser6Time = '';
  String _workUser7Name = '';
  String _workUser7Time = '';
  String _workUser8Name = '';
  String _workUser8Time = '';
  String _workUser9Name = '';
  String _workUser9Time = '';
  String _workUser10Name = '';
  String _workUser10Time = '';
  String _workUser11Name = '';
  String _workUser11Time = '';
  String _workUser12Name = '';
  String _workUser12Time = '';
  String _workUser13Name = '';
  String _workUser13Time = '';
  String _workUser14Name = '';
  String _workUser14Time = '';
  String _workUser15Name = '';
  String _workUser15Time = '';
  String _workUser16Name = '';
  String _workUser16Time = '';

  int _approval = 0;
  String _createdUserId = '';
  String _createdUserName = '';
  DateTime _createdAt = DateTime.now();
  DateTime _expirationAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  String get workUser1Name => _workUser1Name;
  String get workUser1Time => _workUser1Time;
  String get workUser2Name => _workUser2Name;
  String get workUser2Time => _workUser2Time;
  String get workUser3Name => _workUser3Name;
  String get workUser3Time => _workUser3Time;
  String get workUser4Name => _workUser4Name;
  String get workUser4Time => _workUser4Time;
  String get workUser5Name => _workUser5Name;
  String get workUser5Time => _workUser5Time;
  String get workUser6Name => _workUser6Name;
  String get workUser6Time => _workUser6Time;
  String get workUser7Name => _workUser7Name;
  String get workUser7Time => _workUser7Time;
  String get workUser8Name => _workUser8Name;
  String get workUser8Time => _workUser8Time;
  String get workUser9Name => _workUser9Name;
  String get workUser9Time => _workUser9Time;
  String get workUser10Name => _workUser10Name;
  String get workUser10Time => _workUser10Time;
  String get workUser11Name => _workUser11Name;
  String get workUser11Time => _workUser11Time;
  String get workUser12Name => _workUser12Name;
  String get workUser12Time => _workUser12Time;
  String get workUser13Name => _workUser13Name;
  String get workUser13Time => _workUser13Time;
  String get workUser14Name => _workUser14Name;
  String get workUser14Time => _workUser14Time;
  String get workUser15Name => _workUser15Name;
  String get workUser15Time => _workUser15Time;
  String get workUser16Name => _workUser16Name;
  String get workUser16Time => _workUser16Time;

  int get approval => _approval;
  String get createdUserId => _createdUserId;
  String get createdUserName => _createdUserName;
  DateTime get createdAt => _createdAt;
  DateTime get expirationAt => _expirationAt;

  ReportModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _workUser1Name = data['workUser1Name'] ?? '';
    _workUser1Time = data['workUser1Time'] ?? '';
    _workUser2Name = data['workUser2Name'] ?? '';
    _workUser2Time = data['workUser2Time'] ?? '';
    _workUser3Name = data['workUser3Name'] ?? '';
    _workUser3Time = data['workUser3Time'] ?? '';
    _workUser4Name = data['workUser4Name'] ?? '';
    _workUser4Time = data['workUser4Time'] ?? '';
    _workUser5Name = data['workUser5Name'] ?? '';
    _workUser5Time = data['workUser5Time'] ?? '';
    _workUser6Name = data['workUser6Name'] ?? '';
    _workUser6Time = data['workUser6Time'] ?? '';
    _workUser7Name = data['workUser7Name'] ?? '';
    _workUser7Time = data['workUser7Time'] ?? '';
    _workUser8Name = data['workUser8Name'] ?? '';
    _workUser8Time = data['workUser8Time'] ?? '';
    _workUser9Name = data['workUser9Name'] ?? '';
    _workUser9Time = data['workUser9Time'] ?? '';
    _workUser10Name = data['workUser10Name'] ?? '';
    _workUser10Time = data['workUser10Time'] ?? '';
    _workUser11Name = data['workUser11Name'] ?? '';
    _workUser11Time = data['workUser11Time'] ?? '';
    _workUser12Name = data['workUser12Name'] ?? '';
    _workUser12Time = data['workUser12Time'] ?? '';
    _workUser13Name = data['workUser13Name'] ?? '';
    _workUser13Time = data['workUser13Time'] ?? '';
    _workUser14Name = data['workUser14Name'] ?? '';
    _workUser14Time = data['workUser14Time'] ?? '';
    _workUser15Name = data['workUser15Name'] ?? '';
    _workUser15Time = data['workUser15Time'] ?? '';
    _workUser16Name = data['workUser16Name'] ?? '';
    _workUser16Time = data['workUser16Time'] ?? '';

    _approval = data['approval'] ?? 0;
    _createdUserId = data['createdUserId'] ?? '';
    _createdUserName = data['createdUserName'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
    _expirationAt = data['expirationAt'].toDate() ?? DateTime.now();
  }

  String approvalText() {
    switch (_approval) {
      case 0:
        return '承認待ち';
      case 1:
        return '承認済み';
      default:
        return '承認待ち';
    }
  }
}
