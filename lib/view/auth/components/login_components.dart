import 'dart:math';

import 'package:clay_containers/constants.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/services/auth_services.dart';
import 'package:flutter_chat/services/google_auth_services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../controller/auth_controller.dart';
import 'extra_work_components.dart';

Align buildAlignShep(double height, double width,
    {required Random random,
    required double x,
    required double y,
    required double z}) {
  return Align(
    // alignment: Alignment(0, -1),
    alignment: Alignment(x, y),
    child: Transform(
      transform: Matrix4.rotationZ(z),
      child: ClayContainer(
        height: height,
        width: width,
        depth: 20,
        curveType: CurveType.concave,
        color: Colors.amber.shade100,
        borderRadius: random.nextInt(1000).toDouble(),
      ),
    ),
  );
}

Align signInAlign(double height, double width, AuthController authController) {
  return Align(
    alignment: const Alignment(0, 0),
    child: Transform(
      transform: Matrix4.skewY(3),
      child: ClayContainer(
        height: height * 0.4,
        width: width * 0.8,
        depth: -10,
        curveType: CurveType.concave,
        color: Colors.amber.shade50,
        borderRadius: 20,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.03,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GestureDetector(
                  onTap: () {
                    authController.loginSignUp.value = false;
                  },
                  child: Row(
                    children: [
                      Flexible(
                        child: NeumorphicText(
                          "Sign In",
                          style: const NeumorphicStyle(color: Colors.black54),
                          textStyle: NeumorphicTextStyle(fontSize: 35),
                        ),
                      ),
                      // Text("Sign In",style: TextStyle(fontSize: 30),),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    ClayContainer(
                      height: 2,
                      width: ((width * 0.249) < 100) ? width * 0.249 : 100,
                      color: Colors.amberAccent,
                      curveType: CurveType.concave,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: yourTextFormField(
                    textController: authController.textEmail,
                    hintTextFind: "Enter Your Email",
                    textInputAction: TextInputAction.next),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: yourTextFormField(
                    textController: authController.textPassword,
                    hintTextFind: "Enter Your Password",
                    textInputAction: TextInputAction.none),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      // print("object");
                      //todo google Sign In Id To Login Here
                      await GoogleAuthServices.googleAuthServices
                          .googleLoginWithGmail();
                      User? user = AuthServices.authServices.getCurrentUser();
                      if (user != null) {
                        Get.offAndToNamed("/");
                      }
                    },
                    child: Brand(
                      Brands.google,
                      size: 30,
                    ),
                  ),
                  GestureDetector(
                    onPanStart: (details) {
                      authController.loginColor.value = false;
                    },
                    onPanEnd: (details) async {
                      authController.loginColor.value = true;
                      //todo Enter Login Button To On Here
                      String response = await AuthServices.authServices
                          .signInWithEmailAndPasswordMethod(
                              authController.textEmail.text,
                              authController.textPassword.text);
                      User? user = AuthServices.authServices.getCurrentUser();
                      if (user != null && response == "Success") {
                        Get.offAndToNamed("/home");
                      } else {
                        Get.snackbar("Sign Failed!!", response);
                      }
                    },
                    // onTap: () {
                    // },
                    child: Obx(
                      () => ClayContainer(
                        height: 40,
                        width: 80,
                        depth: 10,
                        spread: 3,
                        borderRadius: 10,
                        color: Colors.amber.shade100,
                        curveType: authController.loginColor.value
                            ? CurveType.concave
                            : CurveType.convex,
                        child: const Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
