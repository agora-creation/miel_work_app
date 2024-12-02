import 'package:flutter/material.dart';
import 'package:miel_work_app/models/organization.dart';
import 'package:miel_work_app/models/stock.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/stock.dart';
import 'package:miel_work_app/services/stock_history.dart';

class StockProvider with ChangeNotifier {
  final StockService _stockService = StockService();
  final StockHistoryService _stockHistoryService = StockHistoryService();

  Future<String?> create({
    required OrganizationModel? organization,
    required String number,
    required String name,
    required int quantity,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '在庫品の追加に失敗しました';
    if (number == '') return '在庫Noは必須入力です';
    if (name == '') return '在庫品名は必須入力です';
    if (loginUser == null) return '在庫品の追加に失敗しました';
    try {
      String id = _stockService.id();
      _stockService.create({
        'id': id,
        'organizationId': organization.id,
        'number': number,
        'name': name,
        'quantity': quantity,
        'createdAt': DateTime.now(),
      });
      String stockHistoryId = _stockHistoryService.id();
      _stockHistoryService.create({
        'id': stockHistoryId,
        'stockId': id,
        'type': 1,
        'quantity': quantity,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '在庫品の追加に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required OrganizationModel? organization,
    required StockModel stock,
    required String number,
    required String name,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '在庫品情報の編集に失敗しました';
    if (number == '') return '在庫Noは必須入力です';
    if (name == '') return '在庫品名は必須入力です';
    if (loginUser == null) return '在庫品情報の編集に失敗しました';
    try {
      _stockService.update({
        'id': stock.id,
        'number': number,
        'name': name,
      });
    } catch (e) {
      error = '在庫品情報の編集に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required StockModel stock,
  }) async {
    String? error;
    try {
      _stockService.delete({
        'id': stock.id,
      });
    } catch (e) {
      error = '在庫品の削除に失敗しました';
    }
    return error;
  }
}
