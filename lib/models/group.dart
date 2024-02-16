class GroupModel {
  String _id = '';
  String _name = '';

  String get id => _id;
  String get name => _name;

  GroupModel.fromMap(Map data) {
    _id = data['id'] ?? '';
    _name = data['name'] ?? '';
  }

  Map toMap() => {
        'id': _id,
        'name': _name,
      };
}
