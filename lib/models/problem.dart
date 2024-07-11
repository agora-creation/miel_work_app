import 'package:cloud_firestore/cloud_firestore.dart';

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
  String _picName = '';
  String _targetName = '';
  String _targetAge = '';
  String _targetTel = '';
  String _targetAddress = '';
  String _details = '';
  String _image = '';
  List<String> states = [];
  int _count = 0;
  List<String> readUserIds = [];
  DateTime _createdAt = DateTime.now();
  DateTime _expirationAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  String get type => _type;
  String get picName => _picName;
  String get targetName => _targetName;
  String get targetAge => _targetAge;
  String get targetTel => _targetTel;
  String get targetAddress => _targetAddress;
  String get details => _details;
  String get image => _image;
  int get count => _count;
  DateTime get createdAt => _createdAt;
  DateTime get expirationAt => _expirationAt;

  ProblemModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _type = data['type'] ?? '';
    _picName = data['picName'] ?? '';
    _targetName = data['targetName'] ?? '';
    _targetAge = data['targetAge'] ?? '';
    _targetTel = data['targetTel'] ?? '';
    _targetAddress = data['targetAddress'] ?? '';
    _details = data['details'] ?? '';
    _image = data['image'] ?? '';
    states = _convertStates(data['states']);
    _count = data['count'] ?? 0;
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