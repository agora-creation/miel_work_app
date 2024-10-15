import 'package:cloud_firestore/cloud_firestore.dart';

class LostModel {
  String _id = '';
  String _organizationId = '';
  DateTime _discoveryAt = DateTime.now();
  String _discoveryPlace = '';
  String _discoveryUser = '';
  String _itemNumber = '';
  String _itemName = '';
  String _itemImage = '';
  String _remarks = '';
  int _status = 0;
  DateTime _returnAt = DateTime.now();
  String _returnUser = '';
  String _signImage = '';
  String _memo = '';
  List<String> readUserIds = [];
  DateTime _createdAt = DateTime.now();
  DateTime _expirationAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  DateTime get discoveryAt => _discoveryAt;
  String get discoveryPlace => _discoveryPlace;
  String get discoveryUser => _discoveryUser;
  String get itemNumber => _itemNumber;
  String get itemName => _itemName;
  String get itemImage => _itemImage;
  String get remarks => _remarks;
  int get status => _status;
  DateTime get returnAt => _returnAt;
  String get returnUser => _returnUser;
  String get signImage => _signImage;
  String get memo => _memo;
  DateTime get createdAt => _createdAt;
  DateTime get expirationAt => _expirationAt;

  LostModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _discoveryAt = data['discoveryAt'].toDate() ?? DateTime.now();
    _discoveryPlace = data['discoveryPlace'] ?? '';
    _discoveryUser = data['discoveryUser'] ?? '';
    _itemNumber = data['itemNumber'] ?? '';
    _itemName = data['itemName'] ?? '';
    _itemImage = data['itemImage'] ?? '';
    _remarks = data['remarks'] ?? '';
    _status = data['status'] ?? 0;
    _returnAt = data['returnAt'].toDate() ?? DateTime.now();
    _returnUser = data['returnUser'] ?? '';
    _signImage = data['signImage'] ?? '';
    _memo = data['memo'] ?? '';
    readUserIds = _convertReadUserIds(data['readUserIds']);
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
    _expirationAt = data['expirationAt'].toDate() ?? DateTime.now();
  }

  List<String> _convertReadUserIds(List list) {
    List<String> ret = [];
    for (dynamic id in list) {
      ret.add('$id');
    }
    return ret;
  }

  String statusText() {
    String ret = '';
    switch (status) {
      case 0:
        ret = '保管中';
        break;
      case 1:
        ret = '返却済';
        break;
      case 9:
        ret = '破棄';
        break;
    }
    return ret;
  }
}
