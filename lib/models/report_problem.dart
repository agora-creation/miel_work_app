class ReportProblemModel {
  String _id = '';
  String title = '';
  String deal = '';

  String get id => _id;

  ReportProblemModel.fromMap(Map data) {
    _id = data['id'] ?? '';
    title = data['title'] ?? '';
    deal = data['deal'] ?? '';
  }

  ReportProblemModel.addMap(Map data) {
    _id = data['id'];
    title = data['title'];
    deal = data['deal'];
  }

  Map toMap() => {
        'id': _id,
        'title': title,
        'deal': deal,
      };
}
