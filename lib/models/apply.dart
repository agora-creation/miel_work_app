import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/approval_user.dart';

const List<String> kApplyTypes = ['稟議', '支払伺い', '協議・報告', '企画'];

class ApplyModel {
  String _id = '';
  String _organizationId = '';
  String _groupId = '';
  String _number = '';
  String _type = '';
  String _title = '';
  String _content = '';
  int _price = 0;
  String _file = '';
  String _fileExt = '';
  String _file2 = '';
  String _file2Ext = '';
  String _file3 = '';
  String _file3Ext = '';
  String _file4 = '';
  String _file4Ext = '';
  String _file5 = '';
  String _file5Ext = '';
  String _reason = '';
  int _approval = 0;
  DateTime _approvedAt = DateTime.now();
  List<ApprovalUserModel> approvalUsers = [];
  String _approvalNumber = '';
  String _approvalReason = '';
  String _createdUserId = '';
  String _createdUserName = '';
  DateTime _createdAt = DateTime.now();
  DateTime _expirationAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  String get groupId => _groupId;
  String get number => _number;
  String get type => _type;
  String get title => _title;
  String get content => _content;
  int get price => _price;
  String get file => _file;
  String get fileExt => _fileExt;
  String get file2 => _file2;
  String get file2Ext => _file2Ext;
  String get file3 => _file3;
  String get file3Ext => _file3Ext;
  String get file4 => _file4;
  String get file4Ext => _file4Ext;
  String get file5 => _file5;
  String get file5Ext => _file5Ext;
  String get reason => _reason;
  int get approval => _approval;
  DateTime get approvedAt => _approvedAt;
  String get approvalNumber => _approvalNumber;
  String get approvalReason => _approvalReason;
  String get createdUserId => _createdUserId;
  String get createdUserName => _createdUserName;
  DateTime get createdAt => _createdAt;
  DateTime get expirationAt => _expirationAt;

  ApplyModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _groupId = data['groupId'] ?? '';
    _number = data['number'] ?? '';
    _type = data['type'] ?? '';
    _title = data['title'] ?? '';
    _content = data['content'] ?? '';
    _price = data['price'] ?? 0;
    _file = data['file'] ?? '';
    _fileExt = data['fileExt'] ?? '';
    _file2 = data['file2'] ?? '';
    _file2Ext = data['file2Ext'] ?? '';
    _file3 = data['file3'] ?? '';
    _file3Ext = data['file3Ext'] ?? '';
    _file4 = data['file4'] ?? '';
    _file4Ext = data['file4Ext'] ?? '';
    _file5 = data['file5'] ?? '';
    _file5Ext = data['file5Ext'] ?? '';
    _reason = data['reason'] ?? '';
    _approval = data['approval'] ?? 0;
    _approvedAt = data['approvedAt'].toDate() ?? DateTime.now();
    approvalUsers = _convertApprovalUsers(data['approvalUsers']);
    _approvalNumber = data['approvalNumber'] ?? '';
    _approvalReason = data['approvalReason'] ?? '';
    _createdUserId = data['createdUserId'] ?? '';
    _createdUserName = data['createdUserName'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
    _expirationAt = data['expirationAt'].toDate() ?? DateTime.now();
  }

  List<ApprovalUserModel> _convertApprovalUsers(List list) {
    List<ApprovalUserModel> converted = [];
    for (Map data in list) {
      converted.add(ApprovalUserModel.fromMap(data));
    }
    return converted;
  }

  String formatPrice() {
    return NumberFormat("#,###").format(_price);
  }

  Color typeColor() {
    Color ret = kGrey200Color;
    switch (_type) {
      case '稟議':
        ret = kRed200Color;
        break;
      case '支払伺い':
        ret = kYellowColor;
        break;
      case '協議・報告':
        ret = kCyanColor;
        break;
      case '企画':
        ret = kLightBlueColor;
        break;
      default:
        break;
    }
    return ret;
  }

  String approvalText() {
    switch (_approval) {
      case 0:
        return '承認待ち';
      case 1:
        return '承認済み';
      case 9:
        return '否決';
      default:
        return '承認待ち';
    }
  }
}
