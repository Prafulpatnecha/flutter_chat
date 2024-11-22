import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthServices {
  GoogleAuthServices._();

  static GoogleAuthServices googleAuthServices = GoogleAuthServices._();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> googleLoginWithGmail() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
      );
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(authCredential);
      log(userCredential.user!.email!);
      log(userCredential.user!.photoURL!);
    } catch (e) {
      Get.snackbar("Google Login Failed!!", "Please Try Again");
      log(e.toString());
    }
  }

  Future<void> signOut()
  async {
    await _googleSignIn.signOut();
  }
}
