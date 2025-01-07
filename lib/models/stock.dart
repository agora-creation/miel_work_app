import 'package:cloud_firestore/cloud_firestore.dart';

class StockModel {
  String _id = '';
  String _organizationId = '';
  int _category = 0;
  String _number = '';
  String _name = '';
  int _quantity = 0;
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  int get category => _category;
  String get number => _number;
  String get name => _name;
  int get quantity => _quantity;
  DateTime get createdAt => _createdAt;

  StockModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _category = data['category'] ?? 0;
    _number = data['number'] ?? '';
    _name = data['name'] ?? '';
    _quantity = data['quantity'] ?? 0;
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }

  String categoryText() {
    switch (_category) {
      case 0:
        return '一般在庫';
      case 1:
        return '資産';
      default:
        return '';
    }
  }
}
