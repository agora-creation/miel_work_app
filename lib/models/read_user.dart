class ReadUserModel {
  String _userId = '';
  String _userName = '';
  DateTime _createdAt = DateTime.now();

  String get userId => _userId;
  String get userName => _userName;
  DateTime get createdAt => _createdAt;

  ReadUserModel.fromMap(Map data) {
    _userId = data['userId'] ?? '';
    _userName = data['userName'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }

  Map toMap() => {
        'userId': _userId,
        'userName': _userName,
        'createdAt': _createdAt,
      };
}
