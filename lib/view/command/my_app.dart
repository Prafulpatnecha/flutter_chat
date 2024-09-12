import 'package:flutter/material.dart';
import 'package:flutter_chat/view/auth/login_process_page.dart';
import 'package:get/get.dart';

import '../auth/auth_manager.dart';
import '../home/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeChange.lightTheme,
      // darkTheme: ThemeChange.darkTheme,
      themeMode: ThemeMode.system,
      // initialRoute: '/',
      getPages: [
        GetPage(name: "/", page: () => const AuthManager(),transition: Transition.circularReveal),
        GetPage(name: "/home", page: () => const HomePage(),transition: Transition.circularReveal),
        GetPage(name: "/login", page: () => const LoginProcessPage(),transition: Transition.native),
      ],
    );
  }
}
