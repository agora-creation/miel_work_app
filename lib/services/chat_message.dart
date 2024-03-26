import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_app/models/chat_message.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/read_user.dart';
import 'package:miel_work_app/models/user.dart';

class ChatMessageService {
  String collection = 'chatMessage';
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

  Future updateRead({
    required String chatId,
    required UserModel? loginUser,
  }) async {
    List<ChatMessageModel> messages = [];
    await firestore
        .collection(collection)
        .where('chatId', isEqualTo: chatId)
        .orderBy('createdAt', descending: true)
        .get()
        .then((value) {
      for (DocumentSnapshot<Map<String, dynamic>> map in value.docs) {
        ChatMessageModel message = ChatMessageModel.fromSnapshot(map);
        bool isRead = false;
        for (ReadUserModel readUser in message.readUsers) {
          if (readUser.userId == loginUser?.id) {
            isRead = true;
          }
        }
        if (!isRead) {
          messages.add(message);
        }
      }
    });
    if (messages.isNotEmpty) {
      for (ChatMessageModel message in messages) {
        List<Map> readUsers = [];
        if (message.readUsers.isNotEmpty) {
          for (ReadUserModel readUser in message.readUsers) {
            readUsers.add(readUser.toMap());
          }
        }
        readUsers.add({
          'userId': loginUser?.id,
          'userName': loginUser?.name,
          'createdAt': DateTime.now(),
        });
        update({
          'id': message.id,
          'readUsers': readUsers,
        });
      }
    }
  }

  Future<List<ChatMessageModel>> selectList({
    required String? chatId,
    required UserModel? loginUser,
  }) async {
    List<ChatMessageModel> ret = [];
    await firestore
        .collection(collection)
        .where('chatId', isEqualTo: chatId ?? 'error')
        .orderBy('createdAt', descending: true)
        .get()
        .then((value) {
      for (DocumentSnapshot<Map<String, dynamic>> map in value.docs) {
        ChatMessageModel message = ChatMessageModel.fromSnapshot(map);
        bool isRead = false;
        for (ReadUserModel readUser in message.readUsers) {
          if (readUser.userId == loginUser?.id) {
            isRead = true;
          }
        }
        if (!isRead) {
          ret.add(message);
        }
      }
    });
    return ret;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList({
    required String? chatId,
  }) {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('chatId', isEqualTo: chatId ?? 'error')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamListUnread({
    required String? organizationId,
  }) {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId ?? 'error')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  List<ChatMessageModel> generateList({
    required QuerySnapshot<Map<String, dynamic>>? data,
  }) {
    List<ChatMessageModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ret.add(ChatMessageModel.fromSnapshot(doc));
    }
    return ret;
  }

  List<ChatMessageModel> generateListKeyword({
    required QuerySnapshot<Map<String, dynamic>>? data,
    required String keyword,
  }) {
    List<ChatMessageModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ChatMessageModel message = ChatMessageModel.fromSnapshot(doc);
      if (keyword != '') {
        if (message.content.contains(keyword)) {
          ret.add(message);
        }
      } else {
        ret.add(message);
      }
    }
    return ret;
  }

  List<ChatMessageModel> generateListUnread({
    required QuerySnapshot<Map<String, dynamic>>? data,
    required OrganizationGroupModel? currentGroup,
    required UserModel? loginUser,
  }) {
    List<ChatMessageModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ChatMessageModel message = ChatMessageModel.fromSnapshot(doc);
      if (currentGroup == null) {
        bool isRead = false;
        for (ReadUserModel readUser in message.readUsers) {
          if (readUser.userId == loginUser?.id) {
            isRead = true;
          }
        }
        if (!isRead) {
          ret.add(message);
        }
      } else if (message.groupId == currentGroup.id || message.groupId == '') {
        bool isRead = false;
        for (ReadUserModel readUser in message.readUsers) {
          if (readUser.userId == loginUser?.id) {
            isRead = true;
          }
        }
        if (!isRead) {
          ret.add(message);
        }
      }
    }
    return ret;
  }
}
