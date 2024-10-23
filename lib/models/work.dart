import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/models/work_break.dart';

class WorkModel {
  String _id = '';
  String _organizationId = '';
  String _groupId = '';
  String _userId = '';
  DateTime _startedAt = DateTime.now();
  DateTime _endedAt = DateTime.now();
  List<WorkBreakModel> workBreaks = [];
  DateTime _createdAt = DateTime.now();
  DateTime _expirationAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  String get groupId => _groupId;
  String get userId => _userId;
  DateTime get startedAt => _startedAt;
  DateTime get endedAt => _endedAt;
  DateTime get createdAt => _createdAt;
  DateTime get expirationAt => _expirationAt;

  WorkModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _groupId = data['groupId'] ?? '';
    _userId = data['userId'] ?? '';
    _startedAt = data['startedAt'].toDate() ?? DateTime.now();
    _endedAt = data['endedAt'].toDate() ?? DateTime.now();
    workBreaks = _convertWorkBreaks(data['workBreaks'] ?? []);
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
    _expirationAt = data['expirationAt'].toDate() ?? DateTime.now();
  }

  List<WorkBreakModel> _convertWorkBreaks(List list) {
    List<WorkBreakModel> converted = [];
    for (Map data in list) {
      converted.add(WorkBreakModel.fromMap(data));
    }
    return converted;
  }

  String startedTime() {
    return dateText('HH:mm', startedAt);
  }

  String endedTime() {
    return dateText('HH:mm', endedAt);
  }

  String breakTime() {
    String ret = '00:00';
    if (workBreaks.isNotEmpty) {
      for (WorkBreakModel workBreak in workBreaks) {
        ret = addTime(ret, workBreak.totalTime());
      }
    }
    return ret;
  }

  String totalTime() {
    String ret = '00:00';
    String dateS = dateText('yyyy-MM-dd', startedAt);
    String timeS = '${startedTime()}:00.000';
    DateTime datetimeS = DateTime.parse('$dateS $timeS');
    String dateE = dateText('yyyy-MM-dd', endedAt);
    String timeE = '${endedTime()}:00.000';
    DateTime datetimeE = DateTime.parse('$dateE $timeE');
    //出勤時間と退勤時間の差を求める
    Duration diff = datetimeE.difference(datetimeS);
    String minutes = twoDigits(diff.inMinutes.remainder(60));
    ret = '${twoDigits(diff.inHours)}:$minutes';
    //勤務時間と休憩の合計時間の差を求める
    ret = subTime(ret, breakTime());
    return ret;
  }
}
