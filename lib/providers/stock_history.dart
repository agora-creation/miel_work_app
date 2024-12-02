import 'package:flutter/material.dart';
import 'package:miel_work_app/models/stock.dart';
import 'package:miel_work_app/models/stock_history.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/stock.dart';
import 'package:miel_work_app/services/stock_history.dart';

class StockHistoryProvider with ChangeNotifier {
  final StockService _stockService = StockService();
  final StockHistoryService _stockHistoryService = StockHistoryService();

  Future<String?> create({
    required StockModel stock,
    required int type,
    required int quantity,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '在庫変動履歴の追加に失敗しました';
    try {
      String id = _stockHistoryService.id();
      _stockHistoryService.create({
        'id': id,
        'stockId': stock.id,
        'type': type,
        'quantity': quantity,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
      int newQuantity = stock.quantity;
      switch (type) {
        case 0:
          if (newQuantity > quantity) {
            newQuantity -= quantity;
          } else {
            newQuantity = 0;
          }
          break;
        case 1:
          newQuantity += quantity;
          break;
        default:
          break;
      }
      _stockService.update({
        'id': stock.id,
        'quantity': newQuantity,
      });
    } catch (e) {
      print(e);
      error = '在庫変動履歴の追加に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required StockModel stock,
    required StockHistoryModel stockHistory,
  }) async {
    String? error;
    try {
      _stockHistoryService.delete({
        'id': stockHistory.id,
      });
      int newQuantity = stock.quantity;
      switch (stockHistory.type) {
        case 0:
          newQuantity += stockHistory.quantity;
          break;
        case 1:
          if (newQuantity > stockHistory.quantity) {
            newQuantity -= stockHistory.quantity;
          } else {
            newQuantity = 0;
          }
          break;
        default:
          break;
      }
      _stockService.update({
        'id': stock.id,
        'quantity': newQuantity,
      });
    } catch (e) {
      error = '在庫変動履歴の削除に失敗しました';
    }
    return error;
  }
}
