class GroupModel {
  String _id = '';
  String _code = '';
  String _name = '';

  String get id => _id;
  String get code => _code;
  String get name => _name;

  GroupModel.fromMap(Map data) {
    _id = data['id'] ?? '';
    _code = data['code'] ?? '';
    _name = data['name'] ?? '';
  }

  Map toMap() => {
    'id': _id,
    'code': _code,
    'name': _name,
  };
}