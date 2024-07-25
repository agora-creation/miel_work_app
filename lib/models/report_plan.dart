class ReportPlanModel {
  String _id = '';
  String title = '';
  String time = '';

  String get id => _id;

  ReportPlanModel.fromMap(Map data) {
    _id = data['id'] ?? '';
    title = data['title'] ?? '';
    time = data['time'] ?? '';
  }

  ReportPlanModel.addMap(Map data) {
    _id = data['id'];
    title = data['title'];
    time = data['time'];
  }

  Map toMap() => {
        'id': _id,
        'title': title,
        'time': time,
      };
}
