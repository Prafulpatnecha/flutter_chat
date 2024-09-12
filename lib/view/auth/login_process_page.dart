import 'dart:math';

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter_chat/controller/auth_controller.dart';
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
      body: Obx(
        () => ClayContainer(
          height: height,
          width: width,
          depth: 30,
          curveType: CurveType.convex,
          color: Colors.amber.shade50,
          child: Stack(
            children: [
              ...List.generate(
                40,
                (index) {
                  Random random = Random();
                  return buildAlignShep(height * random.nextDouble() * 0.1,
                      width * random.nextDouble() * 0.1,
                      x: (random.nextBool())
                          ? -random.nextDouble()
                          : random.nextDouble(),
                      y: (random.nextBool())
                          ? -random.nextDouble()
                          : random.nextDouble(),
                      z: random.nextDouble(),
                      random: random);
                },
              ),
              authController.loginSignUp.value
                  ? signInAlign(height, width, authController)
                  : signUpAlign(height, width, authController),
            ],
          ),
        ),
      ),
    );
  }
}
