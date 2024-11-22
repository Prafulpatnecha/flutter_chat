import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatController extends GetxController
{
  RxString receiverEmail="".obs;
  RxString receiverName="".obs;
  RxString image = "".obs;
  TextEditingController txtMassage = TextEditingController();

  void setImage(String url)
  {
    image.value = url;
  }

  void getReceiver(String email,String name)
  {
    receiverName.value = name;
    receiverEmail.value = email;
  }
}