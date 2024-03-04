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
    required int priority,
  }) async {
    ChatModel? ret;
    await firestore
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId)
        .where('groupId', isEqualTo: groupId)
        .where('priority', isEqualTo: priority)
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
    required String? groupId,
  }) async {
    List<ChatModel> ret = [];
    await firestore
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId ?? 'error')
        .where('groupId', isEqualTo: groupId != '' ? groupId : null)
        .orderBy('priority', descending: false)
        .get()
        .then((value) {
      for (DocumentSnapshot<Map<String, dynamic>> map in value.docs) {
        ret.add(ChatModel.fromSnapshot(map));
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
        .orderBy('priority', descending: false)
        .snapshots();
  }

  List<ChatModel> generateList({
    required QuerySnapshot<Map<String, dynamic>>? data,
    required OrganizationGroupModel? currentGroup,
  }) {
    List<ChatModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ChatModel chat = ChatModel.fromSnapshot(doc);
      if (currentGroup == null) {
        ret.add(chat);
      } else if (chat.groupId == currentGroup.id || chat.groupId == '') {
        ret.add(chat);
      }
    }
    return ret;
  }
}
