import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/view/command/my_app.dart';
// import 'package:flutter_chat/view/command/my_app.dart';
import 'firebase_options.dart';
// https://console.firebase.google.com/project/flutterchat-e5565/overview
Future<void> main()
async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  // runApp(const MyChatApp());
}

















// import 'dart:async';
//
// import 'package:clay_containers/clay_containers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_tilt/flutter_tilt.dart';
//
//
// void main() {
//   runApp(const MaterialApp(home: MyApp()));
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
//   Color baseColor = Colors.amber;
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
//     stagger(65-firstDepth, _animationController.value, 0.25)!;
//     final calculatedSecondDepth =
//     stagger(secondDepth, _animationController.value, 0.5)!;
//     final calculatedThirdDepth =
//     stagger(thirdDepth, _animationController.value, 0.75)!;
//     final calculatedFourthDepth =
//     stagger(fourthDepth, _animationController.value, 1)!;
//
//     double height= MediaQuery.of(context).size.height;
//     double width= MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: Tilt(
//         child: ClayTheme(
//           themeData: const ClayThemeData(
//             height: 10,
//             width: 20,
//             borderRadius: 0,
//             textTheme: ClayTextTheme(style: TextStyle()),
//             depth: -10,
//           ),
//           child: ClayContainer(
//             depth: 30,
//             curveType: CurveType.convex,
//             color: Colors.amber.shade100,
//             height: height,
//             width: width,
//             child: ListView.builder(itemCount: 20,
//               itemBuilder:(context, index) =>  Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15.0),
//                 child: ClayContainer(
//                   // height: height * 0.4,
//                   // width: width * 0.8,
//                   // depth: -10,
//                   // curveType: (index%2==0)?CurveType.concave:CurveType.convex,
//                   curveType: CurveType.convex,
//                   // curveType: CurveType.concave,
//                   color: Colors.amber.shade200,
//                   borderRadius: 20,
//                   // color: baseColor,
//                   height: 50,
//                   // width: 240,
//                   spread: 2,
//                   depth: -calculatedFirstDepth.toInt(),
//                   child: Text("data"),
//                   // child: Padding(
//                   //   padding: const EdgeInsets.all(5.0),
//                   //   child: ClayContainer(
//                   //     // height: 120,
//                   //     // width: 120,
//                   //     color: Colors.amber.shade100,
//                   //     borderRadius: 20,
//                   //     depth: -calculatedFourthDepth.toInt(),
//                   //     curveType: CurveType.convex,
//                   //   ),
//                   // ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }