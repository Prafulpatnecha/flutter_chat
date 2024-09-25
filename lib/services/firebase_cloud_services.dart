import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat/modal/chat_model.dart';
import 'package:flutter_chat/modal/user_modal.dart';
import 'package:flutter_chat/services/auth_services.dart';

class FirebaseCloudServices {
  FirebaseCloudServices._();

  static FirebaseCloudServices firebaseCloudServices =
      FirebaseCloudServices._();

  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  Future<void> insertUserIntoFireStore(UserModal userModal) async {
    await firebaseFireStore.collection("users").doc(userModal.email).set({
      "email": userModal.email,
      "phoneNo": userModal.phoneNo,
      "image": userModal.image,
      "name": userModal.name,
      "token": userModal.token,
    });
  }

  //todo read Current user data
  Future<DocumentSnapshot<Map<String, dynamic>>>
      readCurrentUserIntoFireStore() async {
    User? user = AuthServices.authServices.getCurrentUser();
    return await firebaseFireStore.collection('users').doc(user!.email).get();
  }

  //todo read all user data
  Future<QuerySnapshot<Map<String, dynamic>>> readAllUserFromFireStore() async {
    User? user = AuthServices.authServices.getCurrentUser();
    return await firebaseFireStore
        .collection("users")
        .where("email", isNotEqualTo: user!.email)
        .get();
  }

  //todo chat in fire store
  Future<void> addChatFireStore(ChatModel chat) async {
    String? sender = chat.sender;
    String? receiver = chat.receiver;
    List doc = [sender, receiver];
    doc.sort();
    String docId = doc.join("_");
    await firebaseFireStore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .add(chat.toMap(chat));
  }

// todo chat read and and receiver
  Stream<QuerySnapshot<Map<String, dynamic>>> readChatFromFireStore(
      String receiver) {
    String sender = AuthServices.authServices.getCurrentUser()!.email!;
    List doc = [sender, receiver];
    doc.sort();
    String docId = doc.join("_");
    return firebaseFireStore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .orderBy("time", descending: true)
        .snapshots();
  }

  //Todo UPDATE
  Future<void> updateChat(String receiver, String massage, String dcId) async {
    // ChatModel chat ;//update
    String sender = AuthServices.authServices.getCurrentUser()!.email!;
    List doc = [sender, receiver];
    doc.sort();
    String docId = doc.join("_");
    await firebaseFireStore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .doc(dcId)
        .update({
      "message": massage,
      "edit": true,
      "editTime": Timestamp.now(),
    });
  }

  //Todo DELETE ME
  Future<void> deleteChatSenderMe(
      String receiver, bool delete, String dcId) async {
    // ChatModel chat ;//update
    String sender = AuthServices.authServices.getCurrentUser()!.email!;
    List doc = [sender, receiver];
    doc.sort();
    String docId = doc.join("_");

    await firebaseFireStore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .doc(dcId)
        .update({
      "editTime": Timestamp.now(),
      // "delete" : true,//delete all
      "deleteSender": true,
    });
  }

  //Todo DELETE Also
  Future<void> deleteChatSenderAlso(
      String receiver, bool delete, String dcId) async {
    // ChatModel chat ;//update
    String sender = AuthServices.authServices.getCurrentUser()!.email!;
    List doc = [sender, receiver];
    doc.sort();
    String docId = doc.join("_");
    await firebaseFireStore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .doc(dcId)
        .update({
      "editTime": Timestamp.now(),
      "delete": true, //delete all
    });
  }

  //Todo DELETE Receiver
  Future<void> deleteChatReceiver(
      String receiver, bool delete, String dcId) async {
    // ChatModel chat ;//update
    String sender = AuthServices.authServices.getCurrentUser()!.email!;
    List doc = [sender, receiver];
    doc.sort();
    String docId = doc.join("_");
    await firebaseFireStore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .doc(dcId)
        .update({
      "editTime": Timestamp.now(),
      "deleteReceiver": delete, //delete Receiver
    });
  }
}
