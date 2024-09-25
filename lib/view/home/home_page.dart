import 'package:flutter/material.dart';
import 'package:flutter_chat/modal/user_modal.dart';
import 'package:flutter_chat/services/firebase_cloud_services.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:get/get.dart';
import 'package:stories_for_flutter/stories_for_flutter.dart';

import '../../utils/colors_globle.dart';
import 'components/home_components.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        color: containerColor,
        child: Tilt(
          child: Container(
            height: height,
            width: width,
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
                  return const Center(
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
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Stories(
                              displayProgress: true,
                              storyItemList: [
                                StoryItem(
                                    stories: [
                                      Scaffold(
                                        body: Container(
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    "https://wallpapers.com/images/high/whatsapp-chat-cherry-blossom-tree-n83z61y72w2h6hyw.webp",
                                                  ),
                                                  fit: BoxFit.cover)),
                                        ),
                                      )
                                    ],
                                    name: "User",
                                    thumbnail: NetworkImage(userModal[0].image))
                              ],
                            ),
                            Stories(
                              displayProgress: true,
                              storyItemList: List.generate(
                                userModal.length,
                                (index) {
                                  return StoryItem(
                                    stories: [
                                      Scaffold(
                                        body: Container(
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    "https://wallpapers.com/images/high/whatsapp-chat-cherry-blossom-tree-n83z61y72w2h6hyw.webp",
                                                  ),
                                                  fit: BoxFit.cover)),
                                        ),
                                      )
                                    ],
                                    name: userModal[index]
                                        .name
                                        .capitalize
                                        .toString(),
                                    thumbnail:
                                        NetworkImage(userModal[index].image),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Text("Massages",style: TextStyle(fontSize: 20,color: textColor,fontWeight: FontWeight.bold),),
                            const Spacer(),
                            IconButton(onPressed: () {
                              //Todo this is blank and not working... but then using next time...
                            }, icon: const Icon(Icons.search))
                          ],
                        ),
                      ),
                      // Container(height: 10,width: width,color: Colors.blue,),
                      ...List.generate(
                        userModal.length,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: emailAndAllUserAccess(userModal, index),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
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
// Todo appbar golden
//Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 42),
//             child: ClayContainer(
//               depth: 30,
//               spread: 10,
//               curveType: CurveType.concave,
//               // borderRadius: 20,
//               width: width,
//               height: height * 0.07,
//               color: Colors.amber.shade200,
//               customBorderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(20),
//                   topRight: Radius.circular(25)),
//               child: FutureBuilder(
//                 future: FirebaseCloudServices.firebaseCloudServices
//                     .readCurrentUserIntoFireStore(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return Center(
//                       child: Text(snapshot.error.toString()),
//                     );
//                   }
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                   Map? data = snapshot.data!.data();
//                   UserModal userModal = UserModal.fromUser(data!);
//                   return Row(
//                     mainAxisSize: MainAxisSize.min,
//                     // mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       const SizedBox(
//                         width: 15,
//                       ),
//                       ClayContainer(
//                         height: 40,
//                         width: 40,
//                         depth: 50,
//                         spread: 5,
//                         borderRadius: 50,
//                         curveType: CurveType.concave,
//                         color: Colors.amber.shade200,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             image: DecorationImage(
//                                 image: NetworkImage(userModal.image)),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: width * 0.02,
//                       ),
//                       Text(
//                         userModal.name.capitalizeFirst!.toString(),
//                         textAlign: TextAlign.start,
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const Spacer(),
//                       IconButton(
//                           onPressed: () async {
//                             await AuthServices.authServices.signOutEmail();
//                             await GoogleAuthServices.googleAuthServices
//                                 .signOut();
//                             Get.offAndToNamed("/");
//                           },
//                           icon: const Icon(Icons.more_vert))
//                     ],
//                   );
//                 },
//               ),
//             ),
//           )
//
