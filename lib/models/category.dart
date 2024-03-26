import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';

class CategoryModel {
  String _id = '';
  String _organizationId = '';
  String _name = '';
  Color _color = kBlueColor;
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  String get name => _name;
  Color get color => _color;
  DateTime get createdAt => _createdAt;

  CategoryModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _name = data['name'] ?? '';
    _color = Color(int.parse(data['color'], radix: 16));
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }
}
