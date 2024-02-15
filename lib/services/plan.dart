import 'package:cloud_firestore/cloud_firestore.dart';

class PlanService {
  String collection = 'plan';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamList({
    String? organizationId,
    String? groupId,
    String? userId,
  }) {
    return firestore
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId ?? 'error')
        .where('groupId', isEqualTo: groupId)
        .where('userId', isEqualTo: userId)
        .snapshots();
  }
}
