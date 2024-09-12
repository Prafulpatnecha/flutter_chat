import 'package:flutter/material.dart';
import 'package:flutter_chat/services/auth_services.dart';
import 'package:flutter_chat/view/auth/login_process_page.dart';

import '../home/home_page.dart';

class AuthManager extends StatelessWidget {
  const AuthManager({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthServices.authServices.getCurrentUser() == null? const LoginProcessPage():const HomePage();
  }
}

