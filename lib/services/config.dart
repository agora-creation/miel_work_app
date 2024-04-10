import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

class ConfigService {
  String collection = 'config';
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  InAppReview review = InAppReview.instance;

  final String APP_STORE_URL =
      'https://apps.apple.com/jp/app/id6479280967?mt=8';
  final String PLAY_STORE_URL =
      'https://play.google.com/store/apps/details?id=com.agoracreation.miel_work_app';

  Future<bool> versionCheck() async {
    bool ret = false;
    //アプリのバージョンを取得
    PackageInfo info = await PackageInfo.fromPlatform();
    Version currentVersion = Version.parse(info.version);
    //データベースからアップデートしたいバージョンを取得
    final doc = await firestore.collection(collection).doc('1').get();
    Version? newVersion;
    if (Platform.isIOS) {
      newVersion =
          Version.parse(doc.data()!['ios_force_app_version'] as String);
    } else {
      newVersion =
          Version.parse(doc.data()!['android_force_app_version'] as String);
    }
    if (currentVersion < newVersion) {
      ret = true;
    }
    return ret;
  }

  Future<bool> launchStoreReview(BuildContext context) async {
    try {
      if (await review.isAvailable()) {
        review.requestReview();
        return true;
      } else {
        //ストアのURLにフォールバック
        final url = Platform.isIOS ? APP_STORE_URL : PLAY_STORE_URL;
        if (!await launchUrl(Uri.parse(url))) {
          return false;
        }
        return true;
      }
    } catch (e) {
      return false;
    }
  }
}
