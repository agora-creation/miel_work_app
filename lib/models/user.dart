import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String _id = '';
  String _number = '';
  String _name = '';
  String _email = '';
  String _password = '';
  String _job = '';
  String _uid = '';
  List<String> tokens = [];
  bool _admin = false;
  bool _president = false;
  bool _resigned = false;
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get number => _number;
  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get job => _job;
  String get uid => _uid;
  bool get admin => _admin;
  bool get president => _president;
  bool get resigned => _resigned;
  DateTime get createdAt => _createdAt;

  UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _number = data['number'] ?? '';
    _name = data['name'] ?? '';
    _email = data['email'] ?? '';
    _password = data['password'] ?? '';
    _job = data['job'] ?? '';
    _uid = data['uid'] ?? '';
    tokens = _convertTokens(data['tokens'] ?? []);
    _admin = data['admin'] ?? false;
    _president = data['president'] ?? false;
    _resigned = data['resigned'] ?? false;
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }

  List<String> _convertTokens(List list) {
    List<String> ret = [];
    for (dynamic id in list) {
      ret.add('$id');
    }
    return ret;
  }
}
