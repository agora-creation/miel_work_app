class WorkBreakModel {
  String _id = '';
  DateTime _startedAt = DateTime.now();
  DateTime _endedAt = DateTime.now();

  String get id => _id;
  DateTime get startedAt => _startedAt;
  DateTime get endedAt => _endedAt;

  WorkBreakModel.fromMap(Map data) {
    _id = data['id'] ?? '';
    _startedAt = data['startedAt'].toDate() ?? DateTime.now();
    _endedAt = data['endedAt'].toDate() ?? DateTime.now();
  }

  Map toMap() => {
        'id': _id,
        'startedAt': _startedAt,
        'endedAt': _endedAt,
      };
}
