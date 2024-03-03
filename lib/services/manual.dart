import 'package:cloud_firestore/cloud_firestore.dart';

class ManualService {
  String collection = 'manual';
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
    required String? organizationId,
  }) {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId ?? 'error')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
