import 'package:clay_containers/constants.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../modal/user_modal.dart';
import '../../../utils/colors_globle.dart';
import '../../../utils/globle_variable.dart';

Column emailAndAllUserAccess(List<UserModal> userModal, int index) {
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
                      userModal[index].image)
                //todo image set work is not complete <--------------------------------------------------
              ),
            ),
          ),
        ),
      ),
    ],
  );
}