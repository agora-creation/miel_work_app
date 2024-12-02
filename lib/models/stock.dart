import 'package:cloud_firestore/cloud_firestore.dart';

class StockModel {
  String _id = '';
  String _organizationId = '';
  String _number = '';
  String _name = '';
  int _quantity = 0;
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  String get number => _number;
  String get name => _name;
  int get quantity => _quantity;
  DateTime get createdAt => _createdAt;

  StockModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _number = data['number'] ?? '';
    _name = data['name'] ?? '';
    _quantity = data['quantity'] ?? 0;
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }
}
