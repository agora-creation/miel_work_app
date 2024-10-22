class CommentModel {
  String _id = '';
  String _userId = '';
  String _userName = '';
  String _content = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get userId => _userId;
  String get userName => _userName;
  String get content => _content;
  DateTime get createdAt => _createdAt;

  CommentModel.fromMap(Map data) {
    _id = data['id'] ?? '';
    _userId = data['userId'] ?? '';
    _userName = data['userName'] ?? '';
    _content = data['content'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }

  Map toMap() => {
        'id': _id,
        'userId': _userId,
        'userName': _userName,
        'content': _content,
        'createdAt': _createdAt,
      };
}
