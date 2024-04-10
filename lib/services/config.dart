import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

class ConfigService {
  String collection = 'config';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
}
