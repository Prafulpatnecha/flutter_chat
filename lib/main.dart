import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/view/command/my_app.dart';
// import 'package:flutter_chat/view/command/my_app.dart';
import 'firebase_options.dart';
// https://console.firebase.google.com/project/flutterchat-e5565/overview
// import 'package:clay_containers/clay_containers.dart';
// import 'package:get/get.dart';
Future<void> main()
async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  // runApp(const MyChatApp());
}



















//todo close
// class MyChatApp extends StatelessWidget {
//   const MyChatApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       getPages: [
//         GetPage(name: "/", page: () => const HomePage()),
//       ],
//     );
//   }
// }
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     Color baseColor = const Color(0xFFF2F2F2);
//     return Scaffold(
//       body: Container(
//         color: baseColor,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               ClayContainer(
//                 color: baseColor,
//                 height: 200,
//                 width: 200,
//                 borderRadius: 20,
//                 surfaceColor: Colors.blue.shade50,
//                 curveType: CurveType.concave,
//                 depth: 5,
//                 child: const Padding(
//                   padding: EdgeInsets.all(20),
//                   child: Center(child: ClayText("Seize the Clay!", emboss: true, size: 25)),
//                 ),
//               ),
//               ClayContainer(
//                 color: baseColor,
//                 height: 150,
//                 width: 150,
//                 customBorderRadius: const BorderRadius.only(
//                     topRight: Radius.elliptical(150, 150),
//                     bottomLeft: Radius.circular(50)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//todo close


// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
//
//
// class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
//   Color baseColor = Colors.purple.shade100;
//   double firstDepth = 50;
//   double secondDepth = 50;
//   double thirdDepth = 50;
//   double fourthDepth = 50;
//   late AnimationController _animationController;
//
//   @override
//   void initState() {
//     _animationController = AnimationController(
//       vsync: this, // the SingleTickerProviderStateMixin
//       duration: const Duration(seconds: 5),
//     )..addListener(() {
//       setState(() {});
//     });
//
//     _animationController.forward();
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double? stagger(double value, double progress, double delay) {
//       var newProgress = progress - (1 - delay);
//       if (newProgress < 0) newProgress = 0;
//       return value * (newProgress / delay);
//     }
//
//     final calculatedFirstDepth =
//     stagger(firstDepth, _animationController.value, 0.25)!;
//     final calculatedSecondDepth =
//     stagger(secondDepth, _animationController.value, 0.5)!;
//     final calculatedThirdDepth =
//     stagger(thirdDepth, _animationController.value, 0.75)!;
//     final calculatedFourthDepth =
//     stagger(fourthDepth, _animationController.value, 1)!;
//     return Scaffold(
//       body: ColoredBox(
//         color: baseColor,
//         child: Center(
//           child: ClayContainer(
//             color: baseColor,
//             height: 240,
//             width: 240,
//             curveType: CurveType.concave,
//             spread: 30,
//             depth: calculatedFirstDepth.toInt(),
//             child: Center(
//               child: ClayContainer(
//                 height: 200,
//                 width: 200,
//                 depth: calculatedSecondDepth.toInt(),
//                 curveType: CurveType.convex,
//                 color: baseColor,
//                 child: Center(
//                   child: ClayContainer(
//                     height: 160,
//                     width: 160,
//                     color: baseColor,
//                     depth: calculatedThirdDepth.toInt(),
//                     curveType: CurveType.concave,
//                     child: Center(
//                       child: ClayContainer(
//                         height: 120,
//                         width: 120,
//                         color: baseColor,
//                         depth: calculatedFourthDepth.toInt(),
//                         curveType: CurveType.convex,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
