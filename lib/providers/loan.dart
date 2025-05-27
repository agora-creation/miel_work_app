import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/models/loan.dart';
import 'package:miel_work_app/models/organization.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/fm.dart';
import 'package:miel_work_app/services/loan.dart';
import 'package:miel_work_app/services/log.dart';
import 'package:miel_work_app/services/user.dart';
import 'package:signature/signature.dart';

class LoanProvider with ChangeNotifier {
  final LoanService _loanService = LoanService();
  final UserService _userService = UserService();
  final FmService _fmService = FmService();
  final LogService _logService = LogService();

  Future<String?> create({
    required OrganizationModel? organization,
    required DateTime loanAt,
    required String loanUser,
    required String loanCompany,
    required String loanStaff,
    required DateTime returnPlanAt,
    required String itemName,
    required XFile? itemImageXFile,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '貸出物の追加に失敗しました';
    if (loanUser == '') return '貸出先は必須入力です';
    if (loanCompany == '') return '貸出先会社名は必須入力です';
    if (loanStaff == '') return '対応スタッフは必須入力です';
    if (itemName == '') return '品名は必須入力です';
    if (loginUser == null) return '貸出物の追加に失敗しました';
    try {
      String id = _loanService.id();
      String itemImage = '';
      if (itemImageXFile != null) {
        File itemImageFile = File(itemImageXFile.path);
        FirebaseStorage storage = FirebaseStorage.instance;
        String storagePath = 'loan/$id';
        Uint8List? bytes = await FlutterImageCompress.compressWithFile(
          itemImageFile.path,
          quality: 60,
        );
        final task = await storage.ref(storagePath).putData(bytes!);
        itemImage = (await task.ref.getDownloadURL());
      }
      _loanService.create({
        'id': id,
        'organizationId': organization.id,
        'loanAt': loanAt,
        'loanUser': loanUser,
        'loanCompany': loanCompany,
        'loanStaff': loanStaff,
        'returnPlanAt': returnPlanAt,
        'itemName': itemName,
        'itemImage': itemImage,
        'status': 0,
        'returnAt': DateTime.now(),
        'returnUser': '',
        'signImage': '',
        'readUserIds': [loginUser.id],
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
        'expirationAt': DateTime.now().add(const Duration(days: 365)),
      });
      //通知
      List<UserModel> sendUsers = await _userService.selectList(
        userIds: organization.userIds,
      );
      if (sendUsers.isNotEmpty) {
        for (UserModel user in sendUsers) {
          if (user.id == loginUser.id) continue;
          for (final token in user.tokens) {
            _fmService.send(
              token: token,
              title: '貸出物が追加されました',
              body: itemName,
            );
          }
        }
      }
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': organization.id,
        'content': '貸出物を追加しました。',
        'device': 'SP(アプリ)',
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '貸出物の追加に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required OrganizationModel? organization,
    required LoanModel loan,
    required DateTime loanAt,
    required String loanUser,
    required String loanCompany,
    required String loanStaff,
    required DateTime returnPlanAt,
    required String itemName,
    required XFile? itemImageXFile,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '貸出情報の編集に失敗しました';
    if (loanUser == '') return '貸出先は必須入力です';
    if (loanCompany == '') return '貸出先会社名は必須入力です';
    if (loanStaff == '') return '対応スタッフは必須入力です';
    if (itemName == '') return '品名は必須入力です';
    if (loginUser == null) return '貸出情報の編集に失敗しました';
    try {
      String? itemImage;
      if (itemImageXFile != null) {
        File itemImageFile = File(itemImageXFile.path);
        FirebaseStorage storage = FirebaseStorage.instance;
        String storagePath = 'loan/${loan.id}';
        Uint8List? bytes = await FlutterImageCompress.compressWithFile(
          itemImageFile.path,
          quality: 60,
        );
        final task = await storage.ref(storagePath).putData(bytes!);
        itemImage = (await task.ref.getDownloadURL());
      }
      if (itemImage != null) {
        _loanService.update({
          'id': loan.id,
          'loanAt': loanAt,
          'loanUser': loanUser,
          'loanCompany': loanCompany,
          'loanStaff': loanStaff,
          'returnPlanAt': returnPlanAt,
          'itemName': itemName,
          'itemImage': itemImage,
        });
      } else {
        _loanService.update({
          'id': loan.id,
          'loanAt': loanAt,
          'loanUser': loanUser,
          'loanCompany': loanCompany,
          'loanStaff': loanStaff,
          'returnPlanAt': returnPlanAt,
          'itemName': itemName,
        });
      }
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': organization.id,
        'content': '貸出情報を編集しました。',
        'device': 'SP(アプリ)',
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '貸出情報の編集に失敗しました';
    }
    return error;
  }

  Future<String?> updateReturn({
    required OrganizationModel? organization,
    required LoanModel loan,
    required DateTime returnAt,
    required String returnUser,
    required SignatureController signImageController,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '貸出物の返却に失敗しました';
    if (returnUser == '') return '返却スタッフは必須入力です';
    if (loginUser == null) return '貸出物の返却に失敗しました';
    try {
      Uint8List? uploadFile = await signImageController.toPngBytes();
      if (uploadFile == null) return '署名のアップロードに失敗しました';
      String fileName = 'sign.png';
      Reference storageRef =
          FirebaseStorage.instance.ref().child('loan/${loan.id}/$fileName');
      uploadFile = await FlutterImageCompress.compressWithList(
        uploadFile,
        quality: 60,
      );
      UploadTask uploadTask = storageRef.putData(uploadFile);
      TaskSnapshot downloadUrl = await uploadTask;
      String signImage = (await downloadUrl.ref.getDownloadURL());
      _loanService.update({
        'id': loan.id,
        'status': 1,
        'returnAt': returnAt,
        'returnUser': returnUser,
        'signImage': signImage,
      });
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': organization.id,
        'content': '貸出物を返却しました。',
        'device': 'SP(アプリ)',
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '貸出物の返却に失敗しました';
    }
    return error;
  }

  Future<String?> addComment({
    required OrganizationModel? organization,
    required LoanModel loan,
    required String content,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '社内コメントの追記に失敗しました';
    if (content == '') return '社内コメントの追記に失敗しました';
    if (loginUser == null) return '社内コメントの追記に失敗しました';
    try {
      List<Map> comments = [];
      if (loan.comments.isNotEmpty) {
        for (final comment in loan.comments) {
          comments.add(comment.toMap());
        }
      }
      comments.add({
        'id': dateText('yyyyMMddHHmm', DateTime.now()),
        'userId': loginUser.id,
        'userName': loginUser.name,
        'content': content,
        'readUserIds': [loginUser.id],
        'createdAt': DateTime.now(),
      });
      _loanService.update({
        'id': loan.id,
        'comments': comments,
      });
      //通知
      List<UserModel> sendUsers = [];
      sendUsers = await _userService.selectList(
        userIds: organization.userIds,
      );
      if (sendUsers.isNotEmpty) {
        for (UserModel user in sendUsers) {
          if (user.id == loginUser.id) continue;
          for (final token in user.tokens) {
            _fmService.send(
              token: token,
              title: '『[貸出物]${loan.itemName}』に社内コメントが追記されました',
              body: content,
            );
          }
        }
      }
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': organization.id,
        'content': '貸出物に社内コメントを追記しました。',
        'device': 'SP(アプリ)',
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '社内コメントの追記に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required LoanModel loan,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '貸出情報の削除に失敗しました';
    try {
      _loanService.delete({
        'id': loan.id,
      });
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': loan.organizationId,
        'content': '貸出物を削除しました。',
        'device': 'SP(アプリ)',
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '貸出情報の削除に失敗しました';
    }
    return error;
  }
}
