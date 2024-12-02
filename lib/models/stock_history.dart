import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';

class StockHistoryModel {
  String _id = '';
  String _stockId = '';
  int _type = 0;
  int _quantity = 0;
  String _createdUserName = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get stockId => _stockId;
  int get type => _type;
  int get quantity => _quantity;
  String get createdUserName => _createdUserName;
  DateTime get createdAt => _createdAt;

  StockHistoryModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _stockId = data['stockId'] ?? '';
    _type = data['type'] ?? 0;
    _quantity = data['quantity'] ?? 0;
    _createdUserName = data['createdUserName'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }

  String typeText() {
    switch (_type) {
      case 0:
        return '出庫';
      case 1:
        return '入庫';
      default:
        return '';
    }
  }

  Color typeColor() {
    Color ret = kGreyColor.withOpacity(0.3);
    switch (_type) {
      case 0:
        ret = kRedColor.withOpacity(0.3);
        break;
      case 1:
        ret = kBlueColor.withOpacity(0.3);
        break;
      default:
        break;
    }
    return ret;
  }

  String typeSign() {
    switch (_type) {
      case 0:
        return '−';
      case 1:
        return '+';
      default:
        return '';
    }
  }
}
