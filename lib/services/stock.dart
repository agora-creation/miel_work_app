import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/stock.dart';

class StockService {
  String collection = 'stock';
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

  Future<String> getLastNumber({
    required String? organizationId,
  }) async {
    String ret = '1';
    await firestore
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId ?? 'error')
        .orderBy('number', descending: false)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        StockModel stock = StockModel.fromSnapshot(value.docs.last);
        int newNumber = int.parse(stock.number) + 1;
        ret = newNumber.toString();
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
        .orderBy('number', descending: false)
        .snapshots();
  }

  List<StockModel> generateList({
    required QuerySnapshot<Map<String, dynamic>>? data,
  }) {
    List<StockModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ret.add(StockModel.fromSnapshot(doc));
    }
    return ret;
  }
}
