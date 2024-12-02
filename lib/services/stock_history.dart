import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/models/stock_history.dart';

class StockHistoryService {
  String collection = 'stockHistory';
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

  Future<StockHistoryModel?> selectData({
    required String id,
  }) async {
    StockHistoryModel? ret;
    await firestore
        .collection(collection)
        .where('id', isEqualTo: id)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = StockHistoryModel.fromSnapshot(value.docs.first);
      }
    });
    return ret;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList({
    required String? stockId,
    required DateTime? searchStart,
    required DateTime? searchEnd,
  }) {
    if (searchStart != null && searchEnd != null) {
      Timestamp startAt = convertTimestamp(searchStart, false);
      Timestamp endAt = convertTimestamp(searchEnd, true);
      return FirebaseFirestore.instance
          .collection(collection)
          .where('stockId', isEqualTo: stockId ?? 'error')
          .orderBy('createdAt', descending: true)
          .startAt([endAt]).endAt([startAt]).snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection(collection)
          .where('stockId', isEqualTo: stockId ?? 'error')
          .orderBy('createdAt', descending: true)
          .snapshots();
    }
  }

  List<StockHistoryModel> generateList({
    required QuerySnapshot<Map<String, dynamic>>? data,
  }) {
    List<StockHistoryModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ret.add(StockHistoryModel.fromSnapshot(doc));
    }
    return ret;
  }
}
