import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_chat/controller/online_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
      Timer.periodic(const Duration(seconds: 3), (timer) async {
        if(getOnlineController.splashScreenBool.value==true)
        {
          getOnlineController.splashScreenBool.value=false;
            await Navigator.of(context).pushReplacementNamed("/");
        }
      },);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/logo/img.png")),
          ),
        ),
      ),
    );
  }
}
