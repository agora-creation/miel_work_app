import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miel_work_app/models/lost.dart';
import 'package:miel_work_app/models/organization.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/fm.dart';
import 'package:miel_work_app/services/lost.dart';
import 'package:miel_work_app/services/user.dart';
import 'package:signature/signature.dart';

class LostProvider with ChangeNotifier {
  final LostService _lostService = LostService();
  final UserService _userService = UserService();
  final FmService _fmService = FmService();

  Future<String?> create({
    required OrganizationModel? organization,
    required DateTime discoveryAt,
    required String discoveryPlace,
    required String discoveryUser,
    required String itemNumber,
    required String itemName,
    required XFile? itemImageXFile,
    required String remarks,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '落とし物の追加に失敗しました';
    if (discoveryPlace == '') return '発見場所は必須入力です';
    if (discoveryUser == '') return '発見者は必須入力です';
    if (itemName == '') return '品名は必須入力です';
    if (loginUser == null) return '落とし物の追加に失敗しました';
    try {
      String id = _lostService.id();
      String itemImage = '';
      if (itemImageXFile != null) {
        File itemImageFile = File(itemImageXFile.path);
        FirebaseStorage storage = FirebaseStorage.instance;
        String storagePath = 'lost/$id';
        final task = await storage.ref(storagePath).putFile(itemImageFile);
        itemImage = (await task.ref.getDownloadURL());
      }
      _lostService.create({
        'id': id,
        'organizationId': organization.id,
        'discoveryAt': discoveryAt,
        'discoveryPlace': discoveryPlace,
        'discoveryUser': discoveryUser,
        'itemNumber': itemNumber,
        'itemName': itemName,
        'itemImage': itemImage,
        'remarks': remarks,
        'status': 0,
        'returnAt': DateTime.now(),
        'returnUser': '',
        'signImage': '',
        'readUserIds': [loginUser.id],
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
          _fmService.send(
            token: user.token,
            title: '落とし物がありました',
            body: itemName,
          );
        }
      }
    } catch (e) {
      error = '落とし物の追加に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required OrganizationModel? organization,
    required LostModel lost,
    required DateTime discoveryAt,
    required String discoveryPlace,
    required String discoveryUser,
    required String itemNumber,
    required String itemName,
    required XFile? itemImageXFile,
    required String remarks,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '落とし物情報の編集に失敗しました';
    if (discoveryPlace == '') return '発見場所は必須入力です';
    if (discoveryUser == '') return '発見者は必須入力です';
    if (itemName == '') return '品名は必須入力です';
    if (loginUser == null) return '落とし物情報の編集に失敗しました';
    try {
      String? itemImage;
      if (itemImageXFile != null) {
        File itemImageFile = File(itemImageXFile.path);
        FirebaseStorage storage = FirebaseStorage.instance;
        String storagePath = 'lost/${lost.id}';
        final task = await storage.ref(storagePath).putFile(itemImageFile);
        itemImage = (await task.ref.getDownloadURL());
      }
      if (itemImage != null) {
        _lostService.update({
          'id': lost.id,
          'discoveryAt': discoveryAt,
          'discoveryPlace': discoveryPlace,
          'discoveryUser': discoveryUser,
          'itemNumber': itemNumber,
          'itemName': itemName,
          'itemImage': itemImage,
          'remarks': remarks,
        });
      } else {
        _lostService.update({
          'id': lost.id,
          'discoveryAt': discoveryAt,
          'discoveryPlace': discoveryPlace,
          'discoveryUser': discoveryUser,
          'itemNumber': itemNumber,
          'itemName': itemName,
          'remarks': remarks,
        });
      }
    } catch (e) {
      error = '落とし物情報の編集に失敗しました';
    }
    return error;
  }

  Future<String?> updateReturn({
    required OrganizationModel? organization,
    required LostModel lost,
    required DateTime returnAt,
    required String returnUser,
    required SignatureController signImageController,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '落とし物の返却に失敗しました';
    if (returnUser == '') return '返却スタッフは必須入力です';
    if (loginUser == null) return '落とし物の返却に失敗しました';
    try {
      Uint8List? uploadFile = await signImageController.toPngBytes();
      if (uploadFile == null) return '署名のアップロードに失敗しました';
      String fileName = 'sign.png';
      Reference storageRef =
          FirebaseStorage.instance.ref().child('lost/${lost.id}/$fileName');
      UploadTask uploadTask = storageRef.putData(uploadFile);
      TaskSnapshot downloadUrl = await uploadTask;
      String signImage = (await downloadUrl.ref.getDownloadURL());
      _lostService.update({
        'id': lost.id,
        'status': 1,
        'returnAt': returnAt,
        'returnUser': returnUser,
        'signImage': signImage,
      });
    } catch (e) {
      error = '落とし物の返却に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required LostModel lost,
  }) async {
    String? error;
    try {
      _lostService.delete({
        'id': lost.id,
      });
    } catch (e) {
      error = '落とし物情報の削除に失敗しました';
    }
    return error;
  }
}
