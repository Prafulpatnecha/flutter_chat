import 'package:flutter/material.dart';
import 'package:flutter_chat/services/auth_services.dart';
import 'package:flutter_chat/services/google_auth_services.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await AuthServices.authServices.signOutEmail();
              await GoogleAuthServices.googleAuthServices.signOut();
              Get.offAndToNamed("/");
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
        title: const Text("HomePage"),
      ),
      body: Container(),
    );
  }
}
