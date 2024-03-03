import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageService {
  String collection = 'chat';
  String subCollection = 'message';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String id({
    required String? chatId,
  }) {
    return firestore
        .collection(collection)
        .doc(chatId ?? 'error')
        .collection(subCollection)
        .doc()
        .id;
  }

  void create(Map<String, dynamic> values) {
    firestore
        .collection(collection)
        .doc(values['chatId'])
        .collection(subCollection)
        .doc(values['id'])
        .set(values);
  }

  void update(Map<String, dynamic> values) {
    firestore
        .collection(collection)
        .doc(values['chatId'])
        .collection(subCollection)
        .doc(values['id'])
        .update(values);
  }

  void delete(Map<String, dynamic> values) {
    firestore
        .collection(collection)
        .doc(values['chatId'])
        .collection(subCollection)
        .doc(values['id'])
        .delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList({
    required String? chatId,
  }) {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(chatId ?? 'error')
        .collection(subCollection)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
