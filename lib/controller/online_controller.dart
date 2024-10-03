



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/services/firebase_cloud_services.dart';
import 'package:get/get.dart';
GetOnlineController getOnlineController = Get.put(GetOnlineController());
class GetOnlineController extends GetxController{
  RxBool splashScreenBool = true.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    FirebaseCloudServices.firebaseCloudServices.changeOnline(Timestamp.now(), true,false);
  }
  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    FirebaseCloudServices.firebaseCloudServices.changeOnline(Timestamp.now(), false,false);
  }
  @override
  Future<void> dispose() async {
    // TODO: implement dispose
    super.dispose();
    await FirebaseCloudServices.firebaseCloudServices.changeOnline(Timestamp.now(), false,false);
  }
}