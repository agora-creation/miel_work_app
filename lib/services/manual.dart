import 'package:cloud_firestore/cloud_firestore.dart';

class ManualService {
  String collection = 'manual';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList({
    required String? organizationId,
    required String? groupId,
  }) {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId ?? 'error')
        .where('groupId', isEqualTo: groupId != '' ? groupId : null)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
