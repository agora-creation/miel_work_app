import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/chat_message.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/user.dart';

class ChatMessageService {
  String collection = 'chatMessage';
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

  Future updateRead({
    required String chatId,
    required UserModel? loginUser,
  }) async {
    List<ChatMessageModel> messages = [];
    await firestore
        .collection(collection)
        .where('chatId', isEqualTo: chatId)
        .orderBy('createdAt', descending: true)
        .get()
        .then((value) {
      for (DocumentSnapshot<Map<String, dynamic>> map in value.docs) {
        ChatMessageModel message = ChatMessageModel.fromSnapshot(map);
        if (!message.readUserIds.contains(loginUser?.id)) {
          messages.add(message);
        }
      }
    });
    if (messages.isNotEmpty) {
      for (ChatMessageModel message in messages) {
        List<String> readUserIds = message.readUserIds;
        readUserIds.add(loginUser?.id ?? '');
        update({
          'id': message.id,
          'readUserIds': readUserIds,
        });
      }
    }
  }

  Future<List<ChatMessageModel>> selectList({
    required String? chatId,
    required UserModel? loginUser,
  }) async {
    List<ChatMessageModel> ret = [];
    await firestore
        .collection(collection)
        .where('chatId', isEqualTo: chatId ?? 'error')
        .orderBy('createdAt', descending: true)
        .get()
        .then((value) {
      for (DocumentSnapshot<Map<String, dynamic>> map in value.docs) {
        ChatMessageModel message = ChatMessageModel.fromSnapshot(map);
        if (!message.readUserIds.contains(loginUser?.id)) {
          ret.add(message);
        }
      }
    });
    return ret;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList({
    required String? chatId,
  }) {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('chatId', isEqualTo: chatId ?? 'error')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamListUnread({
    required String? organizationId,
  }) {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId ?? 'error')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  List<ChatMessageModel> generateList({
    required QuerySnapshot<Map<String, dynamic>>? data,
  }) {
    List<ChatMessageModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ret.add(ChatMessageModel.fromSnapshot(doc));
    }
    return ret;
  }

  List<ChatMessageModel> generateListUnread({
    required QuerySnapshot<Map<String, dynamic>>? data,
    required OrganizationGroupModel? currentGroup,
    required UserModel? loginUser,
  }) {
    List<ChatMessageModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ChatMessageModel message = ChatMessageModel.fromSnapshot(doc);
      if (currentGroup == null) {
        if (!message.readUserIds.contains(loginUser?.id)) {
          ret.add(message);
        }
      } else if (message.groupId == currentGroup.id || message.groupId == '') {
        if (!message.readUserIds.contains(loginUser?.id)) {
          ret.add(message);
        }
      }
    }
    return ret;
  }
}
