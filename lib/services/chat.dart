import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/chat.dart';
import 'package:miel_work_app/models/organization_group.dart';

class ChatService {
  String collection = 'chat';
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

  Future<ChatModel?> selectData({
    required String organizationId,
    required String groupId,
  }) async {
    ChatModel? ret;
    await firestore
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId)
        .where('groupId', isEqualTo: groupId)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = ChatModel.fromSnapshot(value.docs.first);
      }
    });
    return ret;
  }

  Future<List<ChatModel>> selectList({
    required String? organizationId,
    required OrganizationGroupModel? currentGroup,
  }) async {
    List<ChatModel> ret = [];
    await firestore
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId ?? 'error')
        .orderBy('updatedAt', descending: true)
        .get()
        .then((value) {
      for (DocumentSnapshot<Map<String, dynamic>> map in value.docs) {
        ChatModel chat = ChatModel.fromSnapshot(map);
        if (currentGroup == null) {
          ret.add(chat);
        } else if (chat.groupId == currentGroup.id || chat.groupId == '') {
          ret.add(chat);
        }
      }
    });
    return ret;
  }
}
