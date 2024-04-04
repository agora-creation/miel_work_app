class ApprovalUserModel {
  String _userId = '';
  String _userName = '';
  bool _userPresident = false;
  DateTime _approvedAt = DateTime.now();

  String get userId => _userId;
  String get userName => _userName;
  bool get userPresident => _userPresident;
  DateTime get approvedAt => _approvedAt;

  ApprovalUserModel.fromMap(Map data) {
    _userId = data['userId'] ?? '';
    _userName = data['userName'] ?? '';
    _userPresident = data['userPresident'] ?? false;
    _approvedAt = data['approvedAt'].toDate() ?? DateTime.now();
  }

  Map toMap() => {
        'userId': _userId,
        'userName': _userName,
        'userPresident': _userPresident,
        'approvedAt': _approvedAt,
      };
}
