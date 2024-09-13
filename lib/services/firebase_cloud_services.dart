
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/modal/user_modal.dart';

class FirebaseCloudServices
{
  FirebaseCloudServices._();
  static FirebaseCloudServices firebaseCloudServices = FirebaseCloudServices._();

  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  Future<void> insertUserIntoFireStore(UserModal userModal)
  async {
    await firebaseFireStore.collection("users").doc(userModal.email).set(
      {
        "email": userModal.email,
        "phoneNo": userModal.phoneNo,
        "image": userModal.image,
        "name": userModal.name,
        "token": userModal.token,
      }
    );
  }
}