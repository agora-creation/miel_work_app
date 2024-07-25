import 'package:miel_work_app/common/functions.dart';

class WorkBreakModel {
  String _id = '';
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now();

  String get id => _id;

  WorkBreakModel.fromMap(Map data) {
    _id = data['id'] ?? '';
    startedAt = data['startedAt'].toDate() ?? DateTime.now();
    endedAt = data['endedAt'].toDate() ?? DateTime.now();
  }

  WorkBreakModel.addMap(Map data) {
    _id = data['id'];
    startedAt = data['startedAt'];
    endedAt = data['endedAt'];
  }

  Map toMap() => {
        'id': _id,
        'startedAt': startedAt,
        'endedAt': endedAt,
      };

  String startedTime() {
    return dateText('HH:mm', startedAt);
  }

  String endedTime() {
    return dateText('HH:mm', endedAt);
  }

  String totalTime() {
    String dateS = dateText('yyyy-MM-dd', startedAt);
    String timeS = '${startedTime()}:00.000';
    DateTime datetimeS = DateTime.parse('$dateS $timeS');
    String dateE = dateText('yyyy-MM-dd', endedAt);
    String timeE = '${endedTime()}:00.000';
    DateTime datetimeE = DateTime.parse('$dateE $timeE');
    //休憩開始時間と休憩終了時間の差を求める
    Duration diff = datetimeE.difference(datetimeS);
    String minutes = twoDigits(diff.inMinutes.remainder(60));
    return '${twoDigits(diff.inHours)}:$minutes';
  }
}
