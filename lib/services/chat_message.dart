import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/chat_message.dart';
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

  Future<List<ChatMessageModel>> selectList({
    required String? chatId,
    required UserModel? user,
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
        if (!message.readUserIds.contains(user?.id)) {
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

  bool unreadCheck({
    required QuerySnapshot<Map<String, dynamic>>? data,
    required UserModel? user,
  }) {
    bool ret = false;
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ChatMessageModel message = ChatMessageModel.fromSnapshot(doc);
      if (!message.readUserIds.contains(user?.id)) {
        ret = true;
      }
    }
    return ret;
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
}
