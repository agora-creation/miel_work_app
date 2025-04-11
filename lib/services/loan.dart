import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/loan.dart';

class LoanService {
  String collection = 'loan';
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

  Future<LoanModel?> selectData({
    required String id,
  }) async {
    LoanModel? ret;
    await firestore
        .collection(collection)
        .where('id', isEqualTo: id)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = LoanModel.fromSnapshot(value.docs.first);
      }
    });
    return ret;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList({
    required String? organizationId,
    required List<int> searchStatus,
  }) {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId ?? 'error')
        .where('status', whereIn: searchStatus)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  bool checkAlert({
    required QuerySnapshot<Map<String, dynamic>>? data,
  }) {
    bool ret = false;
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      LoanModel loan = LoanModel.fromSnapshot(doc);
      if (loan.status == 0) {
        ret = true;
      }
    }
    return ret;
  }

  List<LoanModel> generateList({
    required QuerySnapshot<Map<String, dynamic>>? data,
    String? keyword,
  }) {
    List<LoanModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      LoanModel loan = LoanModel.fromSnapshot(doc);
      if (keyword != null && keyword != '') {
        if (loan.loanUser.contains(keyword) ||
            loan.loanCompany.contains(keyword) ||
            loan.loanStaff.contains(keyword) ||
            loan.itemName.contains(keyword)) {
          ret.add(loan);
        }
      } else {
        ret.add(loan);
      }
    }
    return ret;
  }
}
