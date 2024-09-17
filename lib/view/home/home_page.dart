import 'dart:io';

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/modal/user_modal.dart';
import 'package:flutter_chat/services/auth_services.dart';
import 'package:flutter_chat/services/firebase_cloud_services.dart';
import 'package:flutter_chat/services/google_auth_services.dart';
import 'package:flutter_chat/utils/globle_variable.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          ClayContainer(
            height: height,
            width: width,
            depth: 30,
            curveType: CurveType.convex,
            color: Colors.amber.shade100,
            child: Tilt(
              child: ClayContainer(
                height: height,
                width: width,
                depth: 30,
                curveType: CurveType.convex,
                color: Colors.amber.shade100,
                child: FutureBuilder(
                  future: FirebaseCloudServices.firebaseCloudServices
                      .readAllUserFromFireStore(),
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
                    List data = snapshot.data!.docs;
                    List<UserModal> userModal = [];
                    for (var user in data) {
                      userModal.add(UserModal.fromUser(user.data()));
                    }
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: height*0.13,),
                          // Container(height: 10,width: width,color: Colors.blue,),
                          ...List.generate(userModal.length, (index) => Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  chatController.getReceiver(userModal[index].email, userModal[index].name);
                                  Get.toNamed("/chat");
                                },
                                title: Text(userModal[index].name),
                                subtitle: Text(userModal[index].email),
                                leading: ClayContainer(
                                  height: 40,
                                  width: 40,
                                  depth: 50,
                                  spread: 5,
                                  borderRadius: 50,
                                  curveType: CurveType.concave,
                                  color: Colors.amber.shade200,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: //(userModal[index].image.contains('file:'))?
                                          // FileImage(File(userModal[index].image))
                                              NetworkImage(userModal[2].image)
                                        //todo image set work is not complete <--------------------------------------------------
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Tilt(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 42),
              child: ClayContainer(
                depth: 30,
                spread: 10,
                curveType: CurveType.concave,
                // borderRadius: 20,
                width: width,
                height: height * 0.07,
                color: Colors.amber.shade200,
                customBorderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    topRight: Radius.circular(25)),
                child: FutureBuilder(
                  future: FirebaseCloudServices.firebaseCloudServices
                      .readCurrentUserIntoFireStore(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    Map? data = snapshot.data!.data();
                    UserModal userModal = UserModal.fromUser(data!);
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        ClayContainer(
                          height: 40,
                          width: 40,
                          depth: 50,
                          spread: 5,
                          borderRadius: 50,
                          curveType: CurveType.concave,
                          color: Colors.amber.shade200,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(userModal.image)),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        Text(
                          userModal.name.capitalizeFirst!.toString(),
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () async {
                              await AuthServices.authServices.signOutEmail();
                              await GoogleAuthServices.googleAuthServices
                                  .signOut();
                                  Get.offAndToNamed("/");
                            },
                            icon: const Icon(Icons.more_vert))
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Todo Using Next Time
//  IconButton(
//   onPressed: () async {
//
//     Get.offAndToNamed("/");
//   },
//   icon: const Icon(Icons.logout_outlined),
// ),
