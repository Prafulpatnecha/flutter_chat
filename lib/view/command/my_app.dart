import 'package:flutter/material.dart';
import 'package:flutter_chat/view/auth/login_process_page.dart';
import 'package:flutter_chat/view/chat/chat_page.dart';
import 'package:flutter_chat/view/chat/image_view/image_show_page.dart';
import 'package:get/get.dart';

import '../auth/auth_manager.dart';
import '../home/home_page.dart';
import '../profile/profile_page.dart';

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
        GetPage(name: "/chat", page: () => const ChatPage(),transition: Transition.native),
        GetPage(name: "/imageShow", page: () => const ImageShowPage(),transition: Transition.circularReveal),
        GetPage(name: "/profile", page: () => const ProfilePage(),transition: Transition.circularReveal),
      ],
    );
  }
}
