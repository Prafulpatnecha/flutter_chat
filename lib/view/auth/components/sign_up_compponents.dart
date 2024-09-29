import 'dart:io';

import 'package:clay_containers/constants.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat/modal/user_modal.dart';
import 'package:flutter_chat/services/auth_services.dart';
import 'package:flutter_chat/services/cloud_storage_firebase_save_any_files.dart';
import 'package:flutter_chat/services/firebase_cloud_services.dart';
import 'package:flutter_chat/services/google_auth_services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';

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
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GestureDetector(
                onTap: () {
                  authController.loginSignUp.value = true;
                  authController.textPassword.clear();
                  authController.textEmail.clear();
                },
                child: Row(
                  children: [
                    Flexible(
                      child: NeumorphicText(
                        "Sign Up",
                        style: const NeumorphicStyle(
                          color: Colors.black54,
                        ),
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
                  textController: authController.textUserName,
                  hintTextFind: "Enter Your User Name",
                  textInputAction: TextInputAction.next),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
              child: yourTextFormField(
                  textController: authController.textPhoneNo,
                  hintTextFind: "Enter Your Phone No",
                  textInputAction: TextInputAction.next),
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
              child: passwordTextFormField(
                textController: authController.textPassword,
                hintTextFind: "Enter Your Password",
                textInputAction: TextInputAction.next,
                iconButton: IconButton(
                  onPressed: () {
                    authController.passwordHide.value =
                    !authController.passwordHide.value;
                  },
                  icon: (authController.passwordHide.value == true)
                      ? const Icon(
                    Icons.remove_red_eye,
                    color: Colors.amber,
                  )
                      : const Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.amber,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
              child: passwordTextFormField(
                  textController: authController.textConfirmPassword,
                  hintTextFind: "Enter Your Confirm Password",
                  textInputAction: TextInputAction.none,
                  iconButton: IconButton(
                      onPressed: () {
                        authController.passwordHide.value =
                        !authController.passwordHide.value;
                      },
                      icon: (authController.passwordHide.value == true)
                          ? const Icon(
                        Icons.remove_red_eye,
                        color: Colors.amber,
                      )
                          : const Icon(
                        Icons.remove_red_eye_outlined,
                        color: Colors.amber,
                      ))),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GetBuilder<AuthController>(
                  builder: (controller) =>
                      GestureDetector(
                        onTap: () async {
                          //Todo Image Picker Code The Place!
                          ImagePicker imagePicker = ImagePicker();
                          XFile? xFile = await imagePicker.pickImage(
                              source: ImageSource.gallery);
                          // // print("object");
                          authController.imagePath = File(xFile!.path)
                              .obs; //todo image file to save then work but not long time using firebase only this file path save...
                          CloudStorageFirebaseSaveAnyFiles
                              .cloudStorageFirebaseSaveAnyFiles
                              .imageStorageIntoEmail(
                              authController.imagePath!.value);
                          //
                          // Directory imageDirectory= await getApplicationDocumentsDirectory();
                          // authController.imageString.value = "${imageDirectory.absolute}/profileImage.png";
                          // print(authController.imagePath!.value.toString());


                          authController
                              .updateObs(); //any update work then button click...
                        },
                        child: (authController.imagePath == null)
                            ? ClayContainer(
                          height: 50,
                          width: 50,
                          depth: -20,
                          curveType: CurveType.concave,
                          borderRadius: 10,
                          color: Colors.amberAccent.shade100,
                          child: const Icon(
                            Bootstrap.person_add,
                            size: 30,
                          ),
                        )
                            : ClayContainer(
                          height: 50,
                          width: 50,
                          depth: -20,
                          curveType: CurveType.concave,
                          borderRadius: 10,
                          color: Colors.amberAccent.shade100,
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: FileImage(File(
                                      authController.imagePath!.value.path)),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                ),
                GestureDetector(
                  onTap: () async {
                    // print("object");
                    //todo google Sign In Id To Sign Up Here
                    await GoogleAuthServices.googleAuthServices
                        .googleLoginWithGmail();
                    User? user = AuthServices.authServices.getCurrentUser();
                    if (user != null) {
                      Get.offAndToNamed("/");
                    }
                  },
                  child: Brand(
                    Brands.google, //TODO Icon
                    size: 30,
                  ),
                ),
                GestureDetector(
                  onPanStart: (details) {
                    authController.loginColor.value = false;
                  },
                  onPanEnd: (details) async {
                    authController.loginColor.value = true;
                    //todo Enter SignUp Button To On Here
                    if (authController.textPassword.text ==
                        authController.textConfirmPassword.text) {
                      try {
                        await AuthServices.authServices.createSignUp(
                            authController.textEmail.text,
                            authController.textPassword.text);
                        UserModal userModel = UserModal(
                            name: authController.textUserName.text,
                            email: authController.textEmail.text,
                            phoneNo: authController.textPhoneNo.text,
                            token: "",
                            image: authController.imagePath == null
                                ? "https://media.istockphoto.com/id/1316420668/vector/user-icon-human-person-symbol-social-profile-icon-avatar-login-sign-web-user-symbol.jpg?s=612x612&w=0&k=20&c=AhqW2ssX8EeI2IYFm6-ASQ7rfeBWfrFFV4E87SaFhJE="
                                : authController.imagePath!.value.path,
                            online: true,
                            lastTime: Timestamp.now(), typingChat: false);
                        FirebaseCloudServices.firebaseCloudServices
                            .insertUserIntoFireStore(userModel);
                        Get.offAndToNamed('/');
                        authController.imagePath = null;
                        authController.textPhoneNo.clear();
                        authController.textEmail.clear();
                        authController.textConfirmPassword.clear();
                        authController.textPassword.clear();
                        authController.textUserName.clear();
                      } catch (e) {
                        Get.snackbar("Email Check",
                            "Please Check Your Email And Password Try Again!!");
                      }
                    } else {
                      Get.snackbar(
                          "Password Check", "Entered Password Failed!!");
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
                        () =>
                        ClayContainer(
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
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    ),
  );
}
