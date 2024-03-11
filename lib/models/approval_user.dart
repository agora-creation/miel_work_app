class ApprovalUserModel {
  String _userId = '';
  String _userName = '';
  DateTime _approvedAt = DateTime.now();

  String get userId => _userId;
  String get userName => _userName;
  DateTime get approvedAt => _approvedAt;

  ApprovalUserModel.fromMap(Map data) {
    _userId = data['userId'] ?? '';
    _userName = data['userName'] ?? '';
    _approvedAt = data['approvedAt'].toDate() ?? DateTime.now();
  }

  Map toMap() => {
        'userId': _userId,
        'userName': _userName,
        'approvedAt': _approvedAt,
      };
}
