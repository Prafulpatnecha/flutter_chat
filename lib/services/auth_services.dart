import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  AuthServices._();

  static AuthServices authServices = AuthServices._();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // todo create account sign up
  Future<void> createSignUp(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //todo login
  Future<String> signInWithEmailAndPasswordMethod(
      String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Success";
    } catch (e) {
      return e.toString();
    }
  }

  //todo sign out
  Future<void> signOutEmail() async {
    await _firebaseAuth.signOut();
  }

  //todo get current User Detail Check
  User? getCurrentUser() {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      log('"Email : ${user.email}');
    }
    return user;
  }
}
