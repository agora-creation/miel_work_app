class PlanGuardsmanWeekModel {
  String _id = '';
  String week = '';
  String startedTime = '';
  String endedTime = '';

  String get id => _id;

  PlanGuardsmanWeekModel.fromMap(Map data) {
    _id = data['id'] ?? '';
    week = data['week'] ?? '';
    startedTime = data['startedTime'] ?? '';
    endedTime = data['endedTime'] ?? '';
  }

  PlanGuardsmanWeekModel.addMap(Map data) {
    _id = data['id'];
    week = data['week'];
    startedTime = data['startedTime'];
    endedTime = data['endedTime'];
  }

  Map toMap() => {
        'id': _id,
        'week': week,
        'startedTime': startedTime,
        'endedTime': endedTime,
      };
}
