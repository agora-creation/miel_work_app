import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/user.dart';

class UserService {
  String collection = 'user';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void update(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).update(values);
  }

  Future<UserModel?> selectData({
    required String email,
    required String password,
  }) async {
    UserModel? ret;
    await firestore
        .collection(collection)
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = UserModel.fromSnapshot(value.docs.first);
      }
    });
    return ret;
  }
}
