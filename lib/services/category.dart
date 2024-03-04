import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/category.dart';

class CategoryService {
  String collection = 'category';
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

  Future<List<CategoryModel>> selectList({
    required String? organizationId,
  }) async {
    List<CategoryModel> ret = [];
    await firestore
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId ?? 'error')
        .orderBy('createdAt', descending: false)
        .get()
        .then((value) {
      for (DocumentSnapshot<Map<String, dynamic>> map in value.docs) {
        ret.add(CategoryModel.fromSnapshot(map));
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
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  List<CategoryModel> generateList({
    required QuerySnapshot<Map<String, dynamic>>? data,
  }) {
    List<CategoryModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ret.add(CategoryModel.fromSnapshot(doc));
    }
    return ret;
  }
}
