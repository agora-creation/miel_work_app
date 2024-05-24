class ReplySourceModel {
  String _id = '';
  String _content = '';
  String _image = '';
  String _file = '';
  String _fileExt = '';
  String _createdUserName = '';

  String get id => _id;
  String get content => _content;
  String get image => _image;
  String get file => _file;
  String get fileExt => _fileExt;
  String get createdUserName => _createdUserName;

  ReplySourceModel.fromMap(Map data) {
    _id = data['id'] ?? '';
    _content = data['content'] ?? '';
    _image = data['image'] ?? '';
    _file = data['file'] ?? '';
    _fileExt = data['fileExt'] ?? '';
    _createdUserName = data['createdUserName'] ?? '';
  }

  Map toMap() => {
        'id': _id,
        'content': _content,
        'image': _image,
        'file': _file,
        'fileExt': _fileExt,
        'createdUserName': _createdUserName,
      };
}
