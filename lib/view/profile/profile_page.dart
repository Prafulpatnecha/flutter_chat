import 'package:flutter/material.dart';
import 'package:flutter_chat/services/auth_services.dart';
import 'package:flutter_chat/services/firebase_cloud_services.dart';
import 'package:flutter_chat/utils/colors_globle.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: containerColor,
      body: Container(
        height: h,
        width: w,
        // child: StreamBuilder(
        //   stream: FirebaseCloudServices.firebaseCloudServices.readCurrentUserIntoFireStore(),
        //   builder: (context, snapshot) {
        //     return Column(
        //       children: [
        //         SizedBox(height: 100,),
        //         CircleAvatar(
        //           radius: 50,
        //           backgroundImage: NetworkImage(""),
        //         ),
        //       ],
        //     );
        //   }
        // ),
      ),
    );
  }
}
