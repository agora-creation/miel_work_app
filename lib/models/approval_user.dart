class ApprovalUserModel {
  String _userId = '';
  String _userName = '';
  bool _userAdmin = false;
  DateTime _approvedAt = DateTime.now();

  String get userId => _userId;
  String get userName => _userName;
  bool get userAdmin => _userAdmin;
  DateTime get approvedAt => _approvedAt;

  ApprovalUserModel.fromMap(Map data) {
    _userId = data['userId'] ?? '';
    _userName = data['userName'] ?? '';
    _userAdmin = data['userAdmin'] ?? false;
    _approvedAt = data['approvedAt'].toDate() ?? DateTime.now();
  }

  Map toMap() => {
        'userId': _userId,
        'userName': _userName,
        'userAdmin': _userAdmin,
        'approvedAt': _approvedAt,
      };
}
