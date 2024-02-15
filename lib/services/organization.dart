import 'package:cloud_firestore/cloud_firestore.dart';

class OrganizationService {
  String collection = 'organization';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamList({
    String? id,
  }) {
    return firestore
        .collection(collection)
        .where('id', isEqualTo: id ?? 'error')
        .snapshots();
  }
}
