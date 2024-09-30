import 'package:flutter/material.dart';
import 'package:flutter_chat/controller/auth_controller.dart';
import 'package:flutter_chat/modal/user_modal.dart';
import 'package:flutter_chat/services/firebase_cloud_services.dart';
import 'package:flutter_chat/utils/colors_globle.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../services/auth_services.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: colorsGlobleGet.containerColor.value,
      body: GetBuilder<ColorsGloble>(
        builder: (controller) => Obx(() =>
           Container(
            height: h,
            width: w,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: ClipPath(
                    clipper: WaveClipperTwo(),
                    child: Container(
                      height: h * 0.2,
                      width: w,
                      color: colorsGlobleGet.profileColorTop.value,
                    ),
                  ),
                ),
                // Align(
                //   alignment: Alignment.topCenter,
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 40),
                //     child: Row(
                //       children: [
                //
                //       ],
                //     ),
                //   ),
                // ),
                Column(
                  children: [
                    SizedBox(height: 30,),
                    Row(
                      children: [
                        IconButton(onPressed: () {
                          Get.back();
                        }, icon: Icon(Icons.navigate_before,size: 30,color: colorsGlobleGet.textColor.value,)),
                        const Spacer(),
                        IconButton(onPressed: () {
                          colorsGlobleGet.isDark.value=!colorsGlobleGet.isDark.value;
                          if(colorsGlobleGet.isDark.value)
                            {
                              colorsGlobleGet.colorChangeLight();
                            }
                          else
                            {
                              colorsGlobleGet.colorChangeDark();
                            }
                          Get.back();
                        }, icon: Icon(Icons.dark_mode,size: 30,color: colorsGlobleGet.textColor.value,)),
                        IconButton(onPressed: () async {
                          await AuthServices.authServices.signOutEmail();
                          Get.offAndToNamed("/login");
                          //Todo this is blank and not working... but then using next time...
                        }, icon: const Icon(Icons.logout_outlined)),//search
                      ],
                    ),
                    FutureBuilder(
                        future: FirebaseCloudServices.firebaseCloudServices
                            .readCurrentUserIntoFireStore(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(snapshot.error.toString()),
                            );
                          }
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          Map<String, dynamic>? data = snapshot.data!.data();
                          UserModal userModal = UserModal.fromUser(data!);

                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 25,
                                ),
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(userModal.image),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                ListTile(
                                    leading: Icon(Icons.person),
                                    title: Text(
                                      userModal.name,
                                      style: TextStyle(
                                          color: colorsGlobleGet.textColor.value,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    subtitle: Text(userModal.email)),
                                ListTile(
                                  leading:
                                      Icon(Icons.perm_contact_calendar_outlined),
                                  title:
                                      (userModal.phoneNo != '')
                                          ? Text(
                                              "+91-${userModal.phoneNo}",
                                              style: TextStyle(
                                                color: colorsGlobleGet.textColor.value,
                                              ),
                                            )
                                          : const Text(""),
                                  // subtitle: Text(userModal.email)
                                  // (userModal.phoneNo!='')?Text("+91-${userModal.phoneNo}",style: TextStyle(color: textColor,),):const Text(""),
                                )
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
