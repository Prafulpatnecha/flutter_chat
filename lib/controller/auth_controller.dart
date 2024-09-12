import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AuthController extends GetxController
{
  //Todo login_process_page.dart
  RxBool loginSignUp=true.obs;
  RxBool themeBool=false.obs;
  RxBool loginColor=true.obs;
  TextEditingController textEmail = TextEditingController();
  TextEditingController textPassword = TextEditingController();
  TextEditingController textUserName = TextEditingController();
  TextEditingController textPhoneNo = TextEditingController();
  TextEditingController textConfirmPassword = TextEditingController();
}
//Todo links Pub
// https://pub.dev/packages/neumorphic_ui

// Todo work in programs
// late AnimationController controllerAnimation;
  // @override
  // void onInit() {
  //   // TODO: implement onInit
  //   super.onInit();
  //   controllerAnimation=AnimationController(vsync: AnimatedGridState(),
  //   duration: Duration(seconds: 5),
  //   )..repeat();
  // }
  //
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   controllerAnimation.dispose();
  //   super.dispose();
  // }
