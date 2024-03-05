import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/chat_message.dart';

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

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList({
    required String? chatId,
  }) {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('chatId', isEqualTo: chatId ?? 'error')
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
}
