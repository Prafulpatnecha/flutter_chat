import 'package:flutter/material.dart';
import 'package:get/get.dart';

ColorsGloble colorsGlobleGet = Get.put(ColorsGloble());

class ColorsGloble extends GetxController {
  RxBool isDark =true.obs;
  Rx<Color> textSheetDeleteColor = Colors.greenAccent.shade100.obs;
  Rx<Color> textColor = Colors.black.obs;
  Rx<Color> containerColor = Colors.grey.shade200.obs;
  RxList<Color> chatColorList = [
    Colors.orange.shade100,
    Colors.pink.shade100,
    Colors.purple.shade100,
    Colors.grey.shade100,
  ].obs;
  Rx<Color> profileColorTop = Colors.white.obs;
  Rx<Color> textButtonColor = Colors.greenAccent.shade200.obs;
  Rx<Color> chatReadColor = Colors.greenAccent.withOpacity(0.4).obs;
  Rx<Color> chatReadColorCurrentUser = Colors.blue.withOpacity(0.2).obs;
  Rx<Color> cursorTextColor = Colors.black.obs;
  Rx<Color> textChanderColor = Colors.white.obs;
  RxList<Color> dividerColorList = [Colors.red, Colors.cyanAccent].obs;
  Rx<Color> sheetColor = Colors.orange.shade100.withOpacity(0.2).obs;
  Rx<Color> textStyleColor = Colors.grey.shade200.obs;
  Rx<Color> textFieldContainer = Colors.purple.shade50.withOpacity(0.3).obs;
  Rx<Color> appBarColor = Colors.white.withOpacity(0.2).obs;
  Rx<Color> sentMassageCountColor = Colors.blue.withOpacity(0.2).obs;
  Rx<Color> sentTextMassageCountColor = Colors.black.obs;

  RxList colorsDotted = [
    Colors.blue,
    Colors.red,
    Colors.orange,
    Colors.amber,
    Colors.purple,
    Colors.grey,
    Colors.cyanAccent,
    Colors.yellow,
    Colors.deepPurple,
    Colors.brown,
    Colors.tealAccent,
    Colors.greenAccent,
  ].obs;

  void colorChangeDark() {
    textSheetDeleteColor = Colors.greenAccent.shade100.obs;
    textColor = Colors.white.obs;//okay
    containerColor = Colors.white12.obs;//okay
    chatColorList = [
      Colors.black87,
      Colors.black87,
      Colors.black87,
      Colors.black87,
    ].obs;
    profileColorTop = Colors.black.obs;
    textButtonColor = Colors.greenAccent.shade200.obs;
    chatReadColor = Colors.greenAccent.withOpacity(0.4).obs;
    chatReadColorCurrentUser = Colors.blue.withOpacity(0.2).obs;
    cursorTextColor = Colors.black.obs;
    textChanderColor = Colors.white.obs;
    dividerColorList = [Colors.red, Colors.cyanAccent].obs;
    sheetColor = Colors.orange.shade100.withOpacity(0.2).obs;
    textStyleColor = Colors.grey.shade200.obs;
    textFieldContainer = Colors.purple.shade50.withOpacity(0.3).obs;
    appBarColor = Colors.white.withOpacity(0.2).obs;
    sentMassageCountColor = Colors.blue.withOpacity(0.2).obs;
    sentTextMassageCountColor = Colors.black.obs;
    colorsDotted = [
      Colors.blue,
      Colors.red,
      Colors.orange,
      Colors.amber,
      Colors.purple,
      Colors.grey,
      Colors.cyanAccent,
      Colors.yellow,
      Colors.deepPurple,
      Colors.brown,
      Colors.tealAccent,
      Colors.greenAccent,
    ].obs;
    update();
  }
  void colorChangeLight()
  {
     textSheetDeleteColor = Colors.greenAccent.shade100.obs;
     textColor = Colors.black.obs;
    containerColor = Colors.grey.shade200.obs;
     chatColorList = [
      Colors.orange.shade100,
      Colors.pink.shade100,
      Colors.purple.shade100,
      Colors.grey.shade100,
    ].obs;
    profileColorTop = Colors.white.obs;
    textButtonColor = Colors.greenAccent.shade200.obs;
    chatReadColor = Colors.greenAccent.withOpacity(0.4).obs;
    chatReadColorCurrentUser = Colors.blue.withOpacity(0.2).obs;
    cursorTextColor = Colors.black.obs;
    textChanderColor = Colors.white.obs;
    dividerColorList = [Colors.red, Colors.cyanAccent].obs;
    sheetColor = Colors.orange.shade100.withOpacity(0.2).obs;
    textStyleColor = Colors.grey.shade200.obs;
    textFieldContainer = Colors.purple.shade50.withOpacity(0.3).obs;
    appBarColor = Colors.white.withOpacity(0.2).obs;
    sentMassageCountColor = Colors.blue.withOpacity(0.2).obs;
    sentTextMassageCountColor = Colors.black.obs;

    colorsDotted = [
      Colors.blue,
      Colors.red,
      Colors.orange,
      Colors.amber,
      Colors.purple,
      Colors.grey,
      Colors.cyanAccent,
      Colors.yellow,
      Colors.deepPurple,
      Colors.brown,
      Colors.tealAccent,
      Colors.greenAccent,
    ].obs;
  }
}
