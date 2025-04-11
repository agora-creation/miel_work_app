import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/notice.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/user.dart';

class NoticeService {
  String collection = 'notice';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String id() {
    return firestore.collection(collection).doc().id;
  }

  void create(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).set(values);
  }

  void update(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).update(values);
  }

  void delete(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).delete();
  }

  Future<NoticeModel?> selectData({
    required String id,
  }) async {
    NoticeModel? ret;
    await firestore
        .collection(collection)
        .where('id', isEqualTo: id)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = NoticeModel.fromSnapshot(value.docs.first);
      }
    });
    return ret;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList({
    required String? organizationId,
  }) {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId ?? 'error')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  bool checkAlert({
    required QuerySnapshot<Map<String, dynamic>>? data,
    required OrganizationGroupModel? currentGroup,
    required UserModel? user,
  }) {
    bool ret = false;
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      NoticeModel notice = NoticeModel.fromSnapshot(doc);
      if (currentGroup == null) {
        ret = !notice.readUserIds.contains(user?.id);
      } else if (notice.groupId == currentGroup.id || notice.groupId == '') {
        ret = !notice.readUserIds.contains(user?.id);
      }
      if (ret) {
        return ret;
      }
    }
    return ret;
  }

  List<NoticeModel> generateList({
    required QuerySnapshot<Map<String, dynamic>>? data,
    required OrganizationGroupModel? currentGroup,
    String? keyword,
  }) {
    List<NoticeModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      NoticeModel notice = NoticeModel.fromSnapshot(doc);
      if (currentGroup == null) {
        if (keyword != null && keyword != '') {
          if (notice.title.contains(keyword) ||
              notice.content.contains(keyword)) {
            ret.add(notice);
          }
        } else {
          ret.add(notice);
        }
      } else if (notice.groupId == currentGroup.id || notice.groupId == '') {
        if (keyword != null && keyword != '') {
          if (notice.title.contains(keyword) ||
              notice.content.contains(keyword)) {
            ret.add(notice);
          }
        } else {
          ret.add(notice);
        }
      }
    }
    return ret;
  }
}
