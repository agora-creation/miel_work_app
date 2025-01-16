class PlanGarbagemanWeekModel {
  String _id = '';
  String week = '';
  String userId = '';
  String userName = '';
  String startedTime = '';
  String endedTime = '';

  String get id => _id;

  PlanGarbagemanWeekModel.fromMap(Map data) {
    _id = data['id'] ?? '';
    week = data['week'] ?? '';
    userId = data['userId'] ?? '';
    userName = data['userName'] ?? '';
    startedTime = data['startedTime'] ?? '';
    endedTime = data['endedTime'] ?? '';
  }

  PlanGarbagemanWeekModel.addMap(Map data) {
    _id = data['id'];
    week = data['week'];
    userId = data['userId'];
    userName = data['userName'];
    startedTime = data['startedTime'];
    endedTime = data['endedTime'];
  }

  Map toMap() => {
        'id': _id,
        'week': week,
        'userId': userId,
        'userName': userName,
        'startedTime': startedTime,
        'endedTime': endedTime,
      };
}
