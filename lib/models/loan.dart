import 'package:cloud_firestore/cloud_firestore.dart';

class LoanModel {
  String _id = '';
  String _organizationId = '';
  DateTime _loanAt = DateTime.now();
  String _loanUser = '';
  String _loanCompany = '';
  String _loanStaff = '';
  DateTime _returnPlanAt = DateTime.now();
  String _itemName = '';
  String _itemImage = '';
  int _status = 0;
  DateTime _returnAt = DateTime.now();
  String _returnUser = '';
  String _signImage = '';
  List<String> readUserIds = [];
  DateTime _createdAt = DateTime.now();
  DateTime _expirationAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  DateTime get loanAt => _loanAt;
  String get loanUser => _loanUser;
  String get loanCompany => _loanCompany;
  String get loanStaff => _loanStaff;
  DateTime get returnPlanAt => _returnPlanAt;
  String get itemName => _itemName;
  String get itemImage => _itemImage;
  int get status => _status;
  DateTime get returnAt => _returnAt;
  String get returnUser => _returnUser;
  String get signImage => _signImage;
  DateTime get createdAt => _createdAt;
  DateTime get expirationAt => _expirationAt;

  LoanModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _loanAt = data['loanAt'].toDate() ?? DateTime.now();
    _loanUser = data['loanUser'] ?? '';
    _loanCompany = data['loanCompany'] ?? '';
    _loanStaff = data['loanStaff'] ?? '';
    _returnPlanAt = data['returnPlanAt'].toDate() ?? DateTime.now();
    _itemName = data['itemName'] ?? '';
    _itemImage = data['itemImage'] ?? '';
    _status = data['status'] ?? 0;
    _returnAt = data['returnAt'].toDate() ?? DateTime.now();
    _returnUser = data['returnUser'] ?? '';
    _signImage = data['signImage'] ?? '';
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
