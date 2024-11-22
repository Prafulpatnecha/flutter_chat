import 'package:flutter/material.dart';
import 'package:flutter_chat/controller/auth_controller.dart';
import 'package:get/get.dart';

TextFormField yourTextFormField(
    {required TextEditingController textController,
      required String hintTextFind,required TextInputAction textInputAction}) {
  return TextFormField(
    maxLength: null,
    textInputAction: textInputAction,
    controller: textController,
    style: TextStyle(color: Colors.amber.shade800),
    decoration: InputDecoration(
      hintText: hintTextFind,
      hintStyle: TextStyle(
        color: Colors.amber.shade800,
      ),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber.shade800)),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black12),),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.amber.shade800),
      ),
    ),
  );
}

TextFormField passwordTextFormField(
    {required TextEditingController textController,
      required String hintTextFind,required TextInputAction textInputAction,required Widget iconButton}) {
  AuthController authController = Get.put(AuthController());
  return TextFormField(
    maxLength: null,
    obscureText: authController.passwordHide.value,
    textInputAction: textInputAction,
    controller: textController,
    style: TextStyle(color: Colors.amber.shade800),
    decoration: InputDecoration(
      suffixIcon: iconButton,
      hintText: hintTextFind,
      hintStyle: TextStyle(
        color: Colors.amber.shade800,
      ),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber.shade800)),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black12),),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.amber.shade800),
      ),
    ),
  );
}