import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_chat/modal/user_modal.dart';
import 'package:flutter_chat/services/auth_services.dart';
import 'package:flutter_chat/services/firebase_cloud_services.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:get/get.dart';
import 'package:stories_for_flutter/stories_for_flutter.dart';

import '../../controller/online_controller.dart';
import '../../utils/colors_globle.dart';
import 'components/home_components.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this);
  //   FirebaseCloudServices.firebaseCloudServices.changeOnline(Timestamp.now(), true);
  // }
  // final ScrollController _scrollController = ScrollController();
  late final AppLifecycleListener _listener;
  final List<String> _states = <String>[];
  late AppLifecycleState? _state;

  @override
  void initState() {
    super.initState();
    FirebaseCloudServices.firebaseCloudServices.changeOnline(Timestamp.now(), true,false);
    _state = SchedulerBinding.instance.lifecycleState;
    _listener = AppLifecycleListener(
      onShow: () async {
        print('\n\n\nshow\n\n\n');
        await FirebaseCloudServices.firebaseCloudServices.changeOnline(Timestamp.now(), true,false);
      },
      onResume: () async {
        print('\n\n\nresume\n\n\n');
        await FirebaseCloudServices.firebaseCloudServices.changeOnline(Timestamp.now(), true,false);
      },
      onHide: () => print('\n\n\nhide\n\n\n'),
      onInactive: () async {
        print('\n\n\ninactive\n\n\n');
        await FirebaseCloudServices.firebaseCloudServices.changeOnline(Timestamp.now(), false,false);
      },
      onPause: () async {
        print('\n\n\npause\n\n\n');
        await FirebaseCloudServices.firebaseCloudServices.changeOnline(Timestamp.now(), false,false);
      },
      onDetach: () async {
        print("\n\n\n\nonDetach\n\n\n\n");
        await FirebaseCloudServices.firebaseCloudServices.changeOnline(Timestamp.now(), false,false);
      },
      onRestart: () => print('\n\n\nrestart\n\n\n'),
      // This fires for each state change. Callbacks above fire only for
      // specific state transitions.
      // onStateChange: _handleStateChange,
    );
    if (_state != null) {
      _states.add(_state!.name);
    }
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  // void _handleTransition(String name) {
  //   setState(() {
  //     _states.add(name);
  //   });
  //   _scrollController.animateTo(
  //     _scrollController.position.maxScrollExtent,
  //     duration: const Duration(milliseconds: 200),
  //     curve: Curves.easeOut,
  //   );
  // }

  // void _handleStateChange(AppLifecycleState state) {
  //   setState(() {
  //     _state = state;
  //   });
  // }

  // @override
  // Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
  //     await FirebaseCloudServices.firebaseCloudServices.changeOnline(Timestamp.now(), false);
  //   } else if (state == AppLifecycleState.resumed) {
  //     await FirebaseCloudServices.firebaseCloudServices.changeOnline(Timestamp.now(), true);
  //   }
  // }



  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   _listener.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    GetOnlineController getOnlineController=Get.put(GetOnlineController());
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
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
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
                                                    fit: BoxFit.cover),),
                                          ),
                                        )
                                      ],
                                      name: "User",
                                      thumbnail: NetworkImage(userModal[0].image),),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Text("Massages",style: TextStyle(fontSize: 20,color: textColor,fontWeight: FontWeight.bold),),
                            // Text("Massages",style: TextStyle(fontSize: 20,color: textColor,fontWeight: FontWeight.bold),),
                            const Spacer(),
                            IconButton(onPressed: () async {
                              await AuthServices.authServices.signOutEmail();
                              Get.offAndToNamed("/login");
                              //Todo this is blank and not working... but then using next time...
                            }, icon: const Icon(Icons.logout_outlined)),//search
                            IconButton(onPressed: () async {
                              Get.offAndToNamed("/profile");
                            }, icon: const Icon(Icons.person))
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
