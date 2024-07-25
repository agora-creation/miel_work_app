class ReportWorkerModel {
  String _id = '';
  String name = '';
  String time = '';

  String get id => _id;

  ReportWorkerModel.fromMap(Map data) {
    _id = data['id'] ?? '';
    name = data['name'] ?? '';
    time = data['time'] ?? '';
  }

  ReportWorkerModel.addMap(Map data) {
    _id = data['id'];
    name = data['name'];
    time = data['time'];
  }

  Map toMap() => {
        'id': _id,
        'name': name,
        'time': time,
      };
}
