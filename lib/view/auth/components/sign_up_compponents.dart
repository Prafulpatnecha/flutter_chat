
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


Align signUpAlign(double height, double width, AuthController authController) {
  return Align(
    alignment: const Alignment(0, 0),
    child: ClayContainer(
      height: height * 0.65,
      width: width * 0.9,
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
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0),
              child: GestureDetector(
                onTap: () {
                  authController.loginSignUp.value = true;
                },
                child: Row(
                  children: [
                    Flexible(
                      child: NeumorphicText(
                        "Sign Up",
                        style: const NeumorphicStyle(
                          color: Colors.black54,
                        ),
                        textStyle:
                        NeumorphicTextStyle(fontSize: 35),
                      ),
                    ),
                    // Text("Sign In",style: TextStyle(fontSize: 30),),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  ClayContainer(
                    height: 2,
                    width: ((width * 0.249) < 100)
                        ? width * 0.249
                        : 100,
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
              padding: const EdgeInsets.symmetric(
                  vertical: 5.0, horizontal: 15.0),
              child: yourTextFormField(
                  textController: authController.textUserName,
                  hintTextFind: "Enter Your User Name", textInputAction: TextInputAction.next),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 5.0, horizontal: 15.0),
              child: yourTextFormField(
                  textController: authController.textPhoneNo,
                  hintTextFind: "Enter Your Phone No", textInputAction: TextInputAction.next),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 5.0, horizontal: 15.0),
              child: yourTextFormField(
                  textController:
                  authController.textEmail,
                  hintTextFind: "Enter Your Email", textInputAction: TextInputAction.next),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 5.0, horizontal: 15.0),
              child: yourTextFormField(
                  textController: authController.textPassword,
                  hintTextFind: "Enter Your Password", textInputAction: TextInputAction.next),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 5.0, horizontal: 15.0),
              child: yourTextFormField(
                  textController: authController.textConfirmPassword,
                  hintTextFind: "Enter Your Confirm Password", textInputAction: TextInputAction.none),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    //Todo Image Picker Code The Place!
                  },
                  child: ClayContainer(
                    height: 50,
                    width: 50,
                    depth: -20,
                    curveType: CurveType.concave,
                    borderRadius: 10,
                    color: Colors.amberAccent.shade100,
                    child: Icon(
                      Bootstrap.person_add,
                      size: 30,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    // print("object");
                    //todo google Sign In Id To Sign Up Here
                    await GoogleAuthServices.googleAuthServices.googleLoginWithGmail();
                    User? user = AuthServices.authServices.getCurrentUser();
                    if(user!=null)
                      {
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
                        authController.loginColor.value=true;
                    //todo Enter SignUp Button To On Here
                        try{
                          await AuthServices.authServices.createSignUp(authController.textEmail.text, authController.textPassword.text);
                          Get.offAndToNamed('/');
                        }catch(e)
                    {
                        Get.snackbar("Email Check","Please Check Your Email And Password Try Again!!");
                    }
                        // User? user = AuthServices.authServices.getCurrentUser();
                        // if(authController.textEmail.text!=user!.email.toString())
                        //   {
                        //
                        //     authController.loginSignUp.value = true;
                        //   }
                        // if(user.email.toString()==authController.textEmail.text)
                        // {
                        //   Get.snackbar("Email Is Already Exist","Please Try Again!!");
                        // }
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
                          "SignUp",
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
  );
}