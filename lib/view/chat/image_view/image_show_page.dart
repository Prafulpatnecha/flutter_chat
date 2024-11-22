import 'package:flutter/material.dart';
import 'package:flutter_chat/controller/auth_controller.dart';
import 'package:flutter_chat/utils/globle_variable.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ImageShowPage extends StatelessWidget {
  const ImageShowPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(image: NetworkImage(chatController.imageShow.value),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: IconButton(onPressed: () {
              Get.back();
            }, icon: Icon(Icons.navigate_before,color: Colors.white,size: 40,)),
          ),
        ],
      ),
    );
  }
}
