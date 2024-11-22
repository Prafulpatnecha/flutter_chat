import 'dart:math';

import 'package:clay_containers/clay_containers.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_chat/controller/auth_controller.dart';
import 'package:flutter_chat/utils/colors_globle.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';

import 'components/login_components.dart';
import 'components/sign_up_compponents.dart';

// black and amber color set app
class LoginProcessPage extends StatelessWidget {
  const LoginProcessPage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    AuthController authController = Get.put(AuthController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => Container(
          height: height,
          width: width,
          // depth: 30,
          // curveType: CurveType.convex,
          color: colorsGlobleGet.containerColor.value,
          child: Stack(
            children: [

              Align(
                alignment: Alignment.topCenter,
                child: ClipPath(
                  clipper: WaveClipperOne(),
                  child: Container(
                    width: width,
                    height: height*0.31,
                    color: colorsGlobleGet.chatColorList[0],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ClipPath(
                  clipper: WaveClipperOne(),
                  child: Container(
                    width: width,
                    height: height*0.3,
                    color: colorsGlobleGet.chatColorList[3],
                  ),
                ),
              ),
              //todo
              // ...List.generate(
              //   40,
              //   (index) {
              //     Random random = Random();
              //     return buildAlignShep(height * random.nextDouble() * 0.1,
              //         width * random.nextDouble() * 0.1,
              //         x: (random.nextBool())
              //             ? -random.nextDouble()
              //             : random.nextDouble(),
              //         y: (random.nextBool())
              //             ? -random.nextDouble()
              //             : random.nextDouble(),
              //         z: random.nextDouble(),
              //         random: random);
              //   },
              // ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipPath(
                  clipper: WaveClipperTwo(reverse: true),
                  child: Container(
                    width: width,
                    height: height*0.22,
                    color: colorsGlobleGet.chatColorList[1],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipPath(
                  clipper: WaveClipperOne(reverse: true),
                  child: Container(
                    width: width,
                    height: height*0.2,
                    color: colorsGlobleGet.chatColorList[0],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipPath(
                  clipper: WaveClipperTwo(reverse: true),
                  child: Container(
                    width: width,
                    height: height*0.18,
                    color: colorsGlobleGet.chatColorList[2],
                  ),
                ),
              ),
              FlipCard(
                // onFlipDone: (isFront) {
                //   isFront=!isFront;
                // },
                front: signInAlign(height, width, authController),
                back: signUpAlign(height, width, authController),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
