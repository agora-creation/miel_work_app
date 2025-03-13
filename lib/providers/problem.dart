import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/models/organization.dart';
import 'package:miel_work_app/models/problem.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/fm.dart';
import 'package:miel_work_app/services/problem.dart';
import 'package:miel_work_app/services/user.dart';

class ProblemProvider with ChangeNotifier {
  final ProblemService _problemService = ProblemService();
  final UserService _userService = UserService();
  final FmService _fmService = FmService();

  Future<String?> create({
    required OrganizationModel? organization,
    required String type,
    required String title,
    required DateTime createdAt,
    required String picName,
    required String targetName,
    required String targetAge,
    required String targetTel,
    required String targetAddress,
    required String details,
    required XFile? imageXFile,
    required XFile? image2XFile,
    required XFile? image3XFile,
    required List<String> states,
    required int count,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return 'クレーム／要望の追加に失敗しました';
    if (type == '') return '対応項目は必須選択です';
    if (picName == '') return '対応者は必須入力です';
    if (loginUser == null) return 'クレーム／要望の追加に失敗しました';
    try {
      String id = _problemService.id();
      String image = '';
      if (imageXFile != null) {
        File imageFile = File(imageXFile.path);
        FirebaseStorage storage = FirebaseStorage.instance;
        String storagePath = 'problem/$id';
        final task = await storage.ref(storagePath).putFile(imageFile);
        image = (await task.ref.getDownloadURL());
      }
      String image2 = '';
      if (image2XFile != null) {
        File image2File = File(image2XFile.path);
        FirebaseStorage storage = FirebaseStorage.instance;
        String storagePath = 'problem/$id';
        final task = await storage.ref(storagePath).putFile(image2File);
        image2 = (await task.ref.getDownloadURL());
      }
      String image3 = '';
      if (image3XFile != null) {
        File image3File = File(image3XFile.path);
        FirebaseStorage storage = FirebaseStorage.instance;
        String storagePath = 'problem/$id';
        final task = await storage.ref(storagePath).putFile(image3File);
        image3 = (await task.ref.getDownloadURL());
      }
      _problemService.create({
        'id': id,
        'organizationId': organization.id,
        'type': type,
        'title': title,
        'picName': picName,
        'targetName': targetName,
        'targetAge': targetAge,
        'targetTel': targetTel,
        'targetAddress': targetAddress,
        'details': details,
        'image': image,
        'image2': image2,
        'image3': image3,
        'states': states,
        'count': count,
        'processed': false,
        'readUserIds': [loginUser.id],
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': createdAt,
        'expirationAt': createdAt.add(const Duration(days: 365)),
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
              title: 'クレーム／要望が報告されました',
              body: details,
            );
          }
        }
      }
    } catch (e) {
      error = 'クレーム／要望の追加に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required OrganizationModel? organization,
    required ProblemModel problem,
    required String type,
    required String title,
    required DateTime createdAt,
    required String picName,
    required String targetName,
    required String targetAge,
    required String targetTel,
    required String targetAddress,
    required String details,
    required XFile? imageXFile,
    required XFile? image2XFile,
    required XFile? image3XFile,
    required List<String> states,
    required int count,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return 'クレーム／要望情報の編集に失敗しました';
    if (type == '') return '対応項目は必須選択です';
    if (picName == '') return '対応者は必須入力です';
    if (loginUser == null) return 'クレーム／要望情報の編集に失敗しました';
    try {
      String? image;
      if (imageXFile != null) {
        File imageFile = File(imageXFile.path);
        FirebaseStorage storage = FirebaseStorage.instance;
        String storagePath = 'problem/${problem.id}';
        final task = await storage.ref(storagePath).putFile(imageFile);
        image = (await task.ref.getDownloadURL());
      }
      String? image2;
      if (image2XFile != null) {
        File image2File = File(image2XFile.path);
        FirebaseStorage storage = FirebaseStorage.instance;
        String storagePath = 'problem/${problem.id}';
        final task = await storage.ref(storagePath).putFile(image2File);
        image2 = (await task.ref.getDownloadURL());
      }
      String? image3;
      if (image3XFile != null) {
        File image3File = File(image3XFile.path);
        FirebaseStorage storage = FirebaseStorage.instance;
        String storagePath = 'problem/${problem.id}';
        final task = await storage.ref(storagePath).putFile(image3File);
        image3 = (await task.ref.getDownloadURL());
      }
      if (image != null || image2 != null || image3 != null) {
        _problemService.update({
          'id': problem.id,
          'type': type,
          'title': title,
          'picName': picName,
          'targetName': targetName,
          'targetAge': targetAge,
          'targetTel': targetTel,
          'targetAddress': targetAddress,
          'details': details,
          'image': image,
          'image2': image2,
          'image3': image3,
          'states': states,
          'count': count,
          'createdUserId': loginUser.id,
          'createdUserName': loginUser.name,
          'createdAt': createdAt,
          'expirationAt': createdAt.add(const Duration(days: 365)),
        });
      } else {
        _problemService.update({
          'id': problem.id,
          'type': type,
          'title': title,
          'picName': picName,
          'targetName': targetName,
          'targetAge': targetAge,
          'targetTel': targetTel,
          'targetAddress': targetAddress,
          'details': details,
          'states': states,
          'count': count,
          'createdUserId': loginUser.id,
          'createdUserName': loginUser.name,
          'createdAt': createdAt,
          'expirationAt': createdAt.add(const Duration(days: 365)),
        });
      }
    } catch (e) {
      error = 'クレーム／要望情報の編集に失敗しました';
    }
    return error;
  }

  Future<String?> addComment({
    required OrganizationModel? organization,
    required ProblemModel problem,
    required String content,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '社内コメントの追記に失敗しました';
    if (content == '') return '社内コメントの追記に失敗しました';
    if (loginUser == null) return '社内コメントの追記に失敗しました';
    try {
      List<Map> comments = [];
      if (problem.comments.isNotEmpty) {
        for (final comment in problem.comments) {
          comments.add(comment.toMap());
        }
      }
      comments.add({
        'id': dateText('yyyyMMddHHmm', DateTime.now()),
        'userId': loginUser.id,
        'userName': loginUser.name,
        'content': content,
        'createdAt': DateTime.now(),
      });
      _problemService.update({
        'id': problem.id,
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
              title: '『[クレーム／要望情報]${problem.title}』に社内コメントが追記されました',
              body: content,
            );
          }
        }
      }
    } catch (e) {
      error = '社内コメントの追記に失敗しました';
    }
    return error;
  }

  Future<String?> process({
    required ProblemModel problem,
  }) async {
    String? error;
    try {
      _problemService.update({
        'id': problem.id,
        'processed': true,
      });
    } catch (e) {
      error = 'クレーム／要望情報の処理に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required ProblemModel problem,
  }) async {
    String? error;
    try {
      _problemService.delete({
        'id': problem.id,
      });
    } catch (e) {
      error = 'クレーム／要望情報の削除に失敗しました';
    }
    return error;
  }
}
