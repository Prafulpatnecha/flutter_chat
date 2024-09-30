import 'dart:math';

import 'package:clay_containers/constants.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/controller/auth_controller.dart';
import 'package:flutter_chat/services/auth_services.dart';
import 'package:flutter_chat/services/firebase_cloud_services.dart';
import 'package:get/get.dart';
import '../../../modal/chat_model.dart';
import '../../../modal/user_modal.dart';
import '../../../utils/colors_globle.dart';
import '../../../utils/globle_variable.dart';

Column emailAndAllUserAccess(List<UserModal> userModal, int index) {
  Random random =Random();
  return Column(
    children: [
      ListTile(
        onTap: () {
          chatController.getReceiver(
              userModal[index].email,
              userModal[index].name,
              userModal[index].image
          );
          Get.toNamed("/chat");
        },
        title: Text(userModal[index].name),
        subtitle: Text(userModal[index].email),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder(
              stream: FirebaseCloudServices.firebaseCloudServices.readChatFromFireStore(userModal[index].email),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                List data = snapshot.data!.docs;
                List<ChatModel> chatList = [];
                List docIdList = [];
                for (QueryDocumentSnapshot snap in data) {
                  docIdList.add(snap.id);
                  chatList.add(ChatModel.fromChat(snap.data() as Map));
                }
                int value=0;
                for(int i =0 ; i<chatList.length;i++)
                  {
                    if(chatList[i].readAndUnReadMassage==false && chatList[i].sender!=AuthServices.authServices.getCurrentUser()!.email)
                      {
                        value++;
                      }
                  }

                return (value!=0)?Container(
                  // width: 20,
                  // height: 90,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                  color: sentMassageCountColor,
                    shape: BoxShape.circle
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(value.toString(),style: TextStyle(color: sentTextMassageCountColor),),
                  ),):Container();
              }
            ),
          ],
        ),
        leading: ClayContainer(
          height: 40,
          width: 40,
          depth: 50,
          spread: 5,
          borderRadius: 50,
          curveType: CurveType.concave,
          color: containerColor,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: //(userModal[index].image.contains('file:'))?
                  // FileImage(File(userModal[index].image),),
                  NetworkImage(
                      userModal[index].image),
                //todo image set work is not complete <--------------------------------------------------
              ),
            ),
          ),
        ),
      ),
      (userModal.length-1!=index)?Padding(
        padding: const EdgeInsets.symmetric(horizontal: 19.0),
        child: DottedLine(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          lineLength: double.infinity,
          // lineThickness: 0.8,
          dashLength: 3.05,
          // dashColor: Colors.black,
          dashGradient: [colorsDotted[random.nextInt(colorsDotted.length)], colorsDotted[random.nextInt(colorsDotted.length)]],
          dashRadius: 5.0,
          dashGapLength: 3.0,
          dashGapColor: Colors.transparent,
          // dashGapGradient: [Colors.red, Colors.blue],
          dashGapRadius: 0.3,
        ),
      ):Padding(
        padding: const EdgeInsets.symmetric(horizontal: 150.0),
        child: DottedLine(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          // lineLength: double.infinity,
          lineThickness: 0.8,
          dashLength: 0.05,
          dashGradient: [colorsDotted[random.nextInt(colorsDotted.length)], colorsDotted[random.nextInt(colorsDotted.length)]],
          dashRadius: 5.0,
          // dashGapLength: 9.0,

          dashGapColor: Colors.transparent,
          dashGapGradient: [colorsDotted[random.nextInt(colorsDotted.length)], colorsDotted[random.nextInt(colorsDotted.length)]],
          dashGapRadius: 0.0,
        ),
      ),
    ],
  );
}