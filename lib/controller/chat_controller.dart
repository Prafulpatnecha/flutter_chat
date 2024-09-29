import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  RxString receiverEmail = "".obs;
  RxString receiverName = "".obs;
  RxString receiverImage = "".obs;
  TextEditingController txtMassage = TextEditingController();
  void getReceiver(String email, String name,String image) {
    receiverName.value = name;
    receiverEmail.value = email;
    receiverImage.value = image;
  }
}
