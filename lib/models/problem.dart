import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';

const List<String> kProblemTypes = ['問題行動', 'クレーム', '要望', 'その他'];
const List<String> kProblemStates = [
  '注視・経過観察必要',
  '注意・警告済み',
  '出禁確定',
  '繰り返し問題行動・カスハラ状態',
];

class ProblemModel {
  String _id = '';
  String _organizationId = '';
  String _type = '';
  String _title = '';
  String _picName = '';
  String _targetName = '';
  String _targetAge = '';
  String _targetTel = '';
  String _targetAddress = '';
  String _details = '';
  String _image = '';
  String _image2 = '';
  String _image3 = '';
  List<String> states = [];
  int _count = 0;
  bool _processed = false;
  List<String> readUserIds = [];
  DateTime _createdAt = DateTime.now();
  DateTime _expirationAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  String get type => _type;
  String get title => _title;
  String get picName => _picName;
  String get targetName => _targetName;
  String get targetAge => _targetAge;
  String get targetTel => _targetTel;
  String get targetAddress => _targetAddress;
  String get details => _details;
  String get image => _image;
  String get image2 => _image2;
  String get image3 => _image3;
  int get count => _count;
  bool get processed => _processed;
  DateTime get createdAt => _createdAt;
  DateTime get expirationAt => _expirationAt;

  ProblemModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _type = data['type'] ?? '';
    _title = data['title'] ?? '';
    _picName = data['picName'] ?? '';
    _targetName = data['targetName'] ?? '';
    _targetAge = data['targetAge'] ?? '';
    _targetTel = data['targetTel'] ?? '';
    _targetAddress = data['targetAddress'] ?? '';
    _details = data['details'] ?? '';
    _image = data['image'] ?? '';
    _image2 = data['image2'] ?? '';
    _image3 = data['image3'] ?? '';
    states = _convertStates(data['states']);
    _count = data['count'] ?? 0;
    _processed = data['processed'] ?? false;
    readUserIds = _convertReadUserIds(data['readUserIds']);
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
    _expirationAt = data['expirationAt'].toDate() ?? DateTime.now();
  }

  List<String> _convertStates(List list) {
    List<String> ret = [];
    for (dynamic id in list) {
      ret.add('$id');
    }
    return ret;
  }

  List<String> _convertReadUserIds(List list) {
    List<String> ret = [];
    for (dynamic id in list) {
      ret.add('$id');
    }
    return ret;
  }

  Color typeColor() {
    Color ret = kGreyColor.withOpacity(0.3);
    switch (_type) {
      case '問題行動':
        ret = kRedColor.withOpacity(0.3);
        break;
      case 'クレーム':
        ret = kYellowColor.withOpacity(0.3);
        break;
      case '要望':
        ret = kCyanColor.withOpacity(0.3);
        break;
      default:
        break;
    }
    return ret;
  }

  String stateText() {
    String ret = '';
    if (states.isNotEmpty) {
      for (String state in states) {
        if (ret != '') ret += '／';
        ret += state;
      }
    }
    return ret;
  }
}

Color generateProblemColor(String type) {
  Color ret = kGreyColor.withOpacity(0.3);
  switch (type) {
    case '問題行動':
      ret = kRedColor.withOpacity(0.3);
      break;
    case 'クレーム':
      ret = kYellowColor.withOpacity(0.3);
      break;
    case '要望':
      ret = kCyanColor.withOpacity(0.3);
      break;
    default:
      break;
  }
  return ret;
}
